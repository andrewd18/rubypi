require_relative 'planetary_building.rb'
require_relative 'product.rb'

class StorageFacility < PlanetaryBuilding
  
  attr_reader :stored_products
  
  POWERGRID_USAGE = 700
  CPU_USAGE = 500
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 250000.00
  STORAGE_VOLUME = 12000.0
  
  def initialize
	@powergrid_usage = POWERGRID_USAGE
	@cpu_usage = CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	
	@stored_products = Hash.new
	
	return self
  end
  
  def name
	return "Storage Facility"
  end
  
  def store_product(product_name, quantity)
	raise ArgumentError, "First argument must be a String." unless product_name.is_a?(String)
	raise ArgumentError, "Second argument must be a Numeric." unless quantity.is_a?(Numeric)
	
	# Make sure the thing we're adding exists.
	product_instance = Product.find_by_name(product_name)
	if (product_instance == nil)
	  raise ArgumentError, "Named product is not registered in Product class."
	end
	
	# Error if adding this would overflow the storage facility.
	volume_needed_for_product = (product_instance.volume * quantity)
	
	if (volume_needed_for_product > self.volume_available)
	  raise ArgumentError, "Adding this product would overflow the storage silo."
	end
	
	# Ready to add!
	
	# Check to see if we already have a stack.
	# We do have it. Add to existing stack.
	if (@stored_products.has_key?(product_name))
	  @stored_products[product_name] += quantity
	  
	# We don't have it. Make a new stack.
	else
	  @stored_products.store(product_name, quantity)
	end
  end
  
  def store_product_instance(product_instance, quantity)
	raise ArgumentError, "First argument must be a Product." unless product_instance.is_a?(Product)
	
	self.store_product(product_instance.name, quantity)
  end
  
  def remove_all_of_product(product_name)
	raise ArgumentError, "Named product is not stored here." unless @stored_products.has_key?(product_name)
	
	@stored_products.delete(product_name)
  end
  
  def remove_qty_of_product(product_name, quantity_to_remove)
	raise ArgumentError, "Named product is not stored here." unless @stored_products.has_key?(product_name)
	
	current_quantity_of_product = @stored_products[product_name]
	
	if (quantity_to_remove >= current_quantity_of_product)
	  # Remove all of it.
	  self.remove_all_of_product(product_name)
	else
	  # Subtract the quantity requested.
	  @stored_products[product_name] -= quantity_to_remove
	end
	
	return @stored_products[product_name]
  end
  
  def total_volume
	return STORAGE_VOLUME
  end
  
  def volume_available
	return (STORAGE_VOLUME - self.volume_used)
  end
  
  def volume_used
	total_volume_used = 0
	
	@stored_products.each do |product_name, quantity|
	  the_product = Product.find_by_name(product_name)
	  volume_used_for_product = (the_product.volume * quantity)
	  total_volume_used += volume_used_for_product
	end
	
	return total_volume_used
  end
end
