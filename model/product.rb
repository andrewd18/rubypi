require 'yaml'

class Product
  attr_reader :name
  attr_reader :p_level
  
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
  
  def self.all
	return @@product_instances
  end
  
  def self.find_by_name(searched_name)
	@@product_instances.find {|instance| instance.name == searched_name}
  end
  
  def self.find_by_p_level(searched_p_level)
	@@product_instances.select {|instance| instance.p_level == searched_p_level}
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
	abs_filepath = File.expand_path("Products.yml", File.dirname(__FILE__))
	yaml_file = File.open(abs_filepath, "w")

	yaml_file.write(YAML::dump(@@product_instances))

	yaml_file.close
	
	return true
  end
  
  def self.load_from_yaml
	abs_filepath = File.expand_path("Products.yml", File.dirname(__FILE__))
	yaml_file = File.open(abs_filepath, "r")

	@@product_instances = YAML::load(yaml_file)

	yaml_file.close
	
	return @@product_instances
  end

  def initialize(name, p_level)
	existing_product_with_same_name = self.class.find_by_name(name)
	raise ArgumentError, "A product with the name \"#{name}\" already exists." unless existing_product_with_same_name.nil?
	
	# Ok it's a valid name.
	@name = name
	
	raise ArgumentError, "Product p_level must be between 0 and 4." unless (p_level.between?(0, 4))
	
	# Ok, it's a valid level.
	@p_level = p_level
	
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