require_relative 'planetary_building.rb'
require_relative 'extractor_head.rb'

require_relative 'product.rb'

class Extractor < PlanetaryBuilding
  
  attr_accessor :extractor_heads
  attr_reader :product_name
  
  POWERGRID_USAGE = 2600
  CPU_USAGE = 400
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 45000.00
  
  EXTRACTS_P_LEVEL = 0
  
  def initialize(product_name = nil)
	@base_powergrid_usage = POWERGRID_USAGE
	@base_cpu_usage = CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	@product_name = product_name
	
	@extractor_heads = Array.new
	
	return self
  end
  
  def name 
	return "Extractor"
  end
  
  def number_of_heads
	return @extractor_heads.count
  end
  
  def add_extractor_head
	if self.number_of_heads == 10
	  raise "Extractor already has 10 heads."
	else
	  extractor_head_instance = ExtractorHead.new
	  @extractor_heads << extractor_head_instance
	  
	  changed
	  notify_observers()
	  
	  return extractor_head_instance
	end
  end
  
  def remove_extractor_head(head)
	if (@extractor_heads.include?(head))
	  # Lean on array.delete.
	  @extractor_heads.delete(head)
	  
	  changed
	  notify_observers()
	else
	  raise "Extractor Head instance #{head} does not belong to this Extractor."
	end
  end
  
  def remove_all_heads
	@extractor_heads.clear
	
	changed
	notify_observers()
  end
  
  # Override powergrid_usage accessors.
  def powergrid_usage
	total = @base_powergrid_usage
	
	@extractor_heads.each do |head|
	  total = (total + head.powergrid_usage)
	end
	
	return total
  end
  
  def powergrid_usage=(value)
	@base_powergrid_usage = value
  end
  
  # Override cpu_usage accessors.
  def cpu_usage
	total = @base_cpu_usage
	
	@extractor_heads.each do |head|
	  total = (total + head.cpu_usage)
	end
	
	return total
  end
  
  def cpu_usage=(value)
	@base_cpu_usage = value
  end
  
  def accepted_product_names
	list_of_product_instances = Product.find_by_p_level(EXTRACTS_P_LEVEL)
	
	list_of_names = Array.new
	
	list_of_product_instances.each do |product|
	  list_of_names << product.name
	end
	
	return list_of_names
  end
  
  def product_name=(new_product_name)
	# Is it the same value?
	if (@product_name == new_product_name)
	  # Leave immediately but don't call our observers and don't error.
	  return @product_name
	
	# Is it nil?
	elsif (new_product_name == nil)
	  @product_name = nil
	  
	  # Notify our observers that we've changed.
	  changed
	  notify_observers
	  
	  return @product_name
	  
	# Okay, so it's not what we already have and it's not nil.
	# Is it a String?
	elsif (new_product_name.is_a?(String))
	  product_instance = Product.find_by_name(new_product_name)
	  
	  if (product_instance == nil)
		raise ArgumentError, "A Product for #{new_product_name} does not exist."
	  end
	  
	  # Product exists. Check it for P level.
	  if (product_instance.p_level != EXTRACTS_P_LEVEL)
		raise ArgumentError, "The #{new_product_name} Product is not a P-level #{EXTRACTS_P_LEVEL} Product."
	  end
	  
	  @product_name = new_product_name
	  
	  # Notify our observers that we've changed.
	  changed
	  notify_observers
	  
	# Is it something else?
	else
	  # Well, I don't want it so go away.
	  raise ArgumentError
	end
  end
  
  def product
	Product.find_by_name(@product_name)
  end
end
