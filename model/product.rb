require 'yaml'
require 'net/http'
require 'rexml/document'

class Product
  attr_reader :name
  attr_reader :p_level
  attr_reader :eve_db_id
  attr_accessor :eve_central_median
  
  # Values confirmed as of Odyssey 1.0.10.
  
  P_LEVEL_TO_VOLUME = {0 => 0.01,
                       1 => 0.38,
                       2 => 1.50,
                       3 => 6.00,
                       4 => 100 }
  
  P_LEVEL_TO_IMPORT_COST = {0 => 2.50,
                            1 => 250.00,
                            2 => 4500.00,
                            3 => 35000.00,
                            4 => 675000.00}
  
  P_LEVEL_TO_EXPORT_COST = {0 => 5.00,
                            1 => 500.00,
                            2 => 9000.00,
                            3 => 70000.00,
                            4 => 1350000.00}
  
  @@product_instances = Array.new
  @@last_updated_time = nil
  
  def self.all
	return @@product_instances
  end
  
  def self.find_by_name(searched_name)
	# Find returns the first matching instance or nil.
	@@product_instances.find {|instance| instance.name == searched_name}
  end
  
  def self.find_by_p_level(searched_p_level)
	@@product_instances.select {|instance| instance.p_level == searched_p_level}
  end
  
  def self.find_by_eve_db_id(searched_db_id)
	# Find returns the first matching instance or nil.
	@@product_instances.find {|instance| instance.eve_db_id == searched_db_id}
  end
  
  def self.find_or_create(name, p_level)
	product_searched_for = self.find_by_name(name)
	
	if (product_searched_for == nil)
	  # Doesn't exist yet. Create and return a new one.
	  return self.new(name, p_level)
	else
	  # It already exists. Return it.
	  return product_searched_for
	end
  end
  
  def self.delete(product_instance)
	raise ArgumentError, "Not a Product." unless product_instance.is_a?(Product)
	
	return @@product_instances.delete(product_instance)
  end
  
  def self.save_to_yaml
	product_instance_file_path = File.expand_path("Products.yml", File.dirname(__FILE__))
	
	product_instance_file = File.open(product_instance_file_path, "w")
	product_instance_file.write(YAML::dump(@@product_instances))
	product_instance_file.close
	
	last_updated_file_path = File.expand_path("Products_Last_Updated_Time.yml", File.dirname(__FILE__))
	last_updated_file = File.open(last_updated_file_path, "w")
	last_updated_file.write(YAML::dump(Time.now))
	last_updated_file.close
	
	return true
  end
  
  def self.load_from_yaml
	product_instance_file_path = File.expand_path("Products.yml", File.dirname(__FILE__))
	product_instance_file_path = File.open(product_instance_file_path, "r")
	@@product_instances = YAML::load(product_instance_file_path)
	product_instance_file_path.close
	
	last_updated_file_path = File.expand_path("Products_Last_Updated_Time.yml", File.dirname(__FILE__))
	last_updated_file = File.open(last_updated_file_path, "r")
	@@last_updated_time = YAML::load(last_updated_file)
	last_updated_file.close
	
	return @@product_instances
  end
  
  def self.update_eve_central_values
	return false unless (@@product_instances != [])
	
	# Create params list.
	product_ids = []
	
	@@product_instances.each do |product|
		if (product.eve_db_id != nil)
			product_ids << product.eve_db_id
		end
	end
	
	marketstat_url = URI('http://api.eve-central.com/api/marketstat')
	url_params = { :typeid => product_ids }
	
	marketstat_url.query = URI.encode_www_form(url_params)
	
	# Pull down XML.
	# 
	evec_request = Net::HTTP::Get.new(marketstat_url)
	evec_request.add_field('User-Agent', 'RubyPI')
	
	http_result = Net::HTTP.start(marketstat_url.host, marketstat_url.port) {|http| http.request(evec_request) }
	
	raw_xml_output = ""
	
	if http_result.is_a?(Net::HTTPSuccess)
		raw_xml_output = http_result.body
	else
		return false
	end
	
	rexml_doc = REXML::Document.new raw_xml_output
	
	# For each XML element within the marketstat tag...
	rexml_doc.elements.each("evec_api/marketstat/type") do |type_tag|
		
		# Get the ID. This returns a string.
		type_id = type_tag.attributes["id"]
		
		# Find the matching product instance.
		product_instance = self.find_by_eve_db_id(type_id.to_i)
		
		if (product_instance.nil?)
		  puts "Unknown type_id: #{type_id}, #{type_id.class}"
		else
		  # Update the product instance with the eve_central median value.
		  tag_value = type_tag.elements["all/median"].text
		  product_instance.eve_central_median = tag_value.to_f
		end
	end
	
	# Force a save to the Products.yml file.
	self.save_to_yaml
	
	return true
  end
  
  def self.last_updated_time
	return @@last_updated_time
  end

  def initialize(name, p_level, eve_db_id = nil, eve_central_median = nil)
	existing_product_with_same_name = self.class.find_by_name(name)
	raise ArgumentError, "A product with the name \"#{name}\" already exists." unless existing_product_with_same_name.nil?
	
	# Ok it's a valid name.
	@name = name
	
	raise ArgumentError, "Product p_level must be between 0 and 4." unless (p_level.between?(0, 4))
	
	# Ok, it's a valid level.
	@p_level = p_level
	@eve_db_id = eve_db_id
	@eve_central_value = eve_central_median
	
	@@product_instances << self
	
	return self
  end
  
  def set_p_level(level)
	if (level.between?(0, 4))
	  # Ok, it's a valid level.
	  # Let's make sure we're not setting something we already have.
	  if (level == @p_level)
		# No change in the value.
		return
	  end
	  
	  @p_level = level
	else
	  # Invalid level passed.
	  raise ArgumentError, "Passed in level must be between 0 and 4."
	end
  end
  
  def volume
	return P_LEVEL_TO_VOLUME[@p_level]
  end
  
  def import_cost
	return P_LEVEL_TO_IMPORT_COST[@p_level]
  end
  
  def export_cost
	return P_LEVEL_TO_EXPORT_COST[@p_level]
  end
  
  def import_cost_for_quantity(quantity)
	raise ArgumentError unless quantity.is_a?(Numeric)
	
	return (self.import_cost * quantity)
  end
  
  def export_cost_for_quantity(quantity)
	raise ArgumentError unless quantity.is_a?(Numeric)
	
	return (self.export_cost * quantity)
  end
end