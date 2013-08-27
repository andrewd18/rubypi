# Defines functions for a storage location in a factory based off the factory's schematics.
# 
# Expects the factory class
# 
# Including class must:
#  * call self.industrial_facility_storage_schematic_changed whenever the schematic changes.

require_relative 'product.rb'
require_relative 'schematic.rb'

module IndustrialFacilityStorage
  def stored_products
	return @stored_products ||= Hash.new
  end
  
  def stored_products=(new_stored_products)
	raise ArgumentError, "Argument is not a Hash." unless new_stored_products.is_a?(Hash)
	
	# Remove any keys where their value is equal to or below.
	new_stored_products.keep_if {|key, value| value > 0}
	
	@stored_products = new_stored_products
  end
  
  def industrial_facility_storage_schematic_changed
	if (self.schematic.nil?)
	  # Erase product categories and quantities entirely.
	  stored_products.clear
	else
	  # Erase product categories and quantities entirely.
	  stored_products.clear
	  
	  # Get the new storage mins and max quantities.
	  self.schematic.inputs.each_pair do |product_name, max_storable_quantity|
		# Assign to product_name with zero stored by default.
		stored_products[product_name] = 0
	  end
	end
  end
  
  def store_product(product_name, quantity)
	raise ArgumentError, "Schematic is not set." unless (self.schematic != nil)
	raise ArgumentError, "Named product is not part of the set Schematic." unless self.schematic.inputs.has_key?(product_name)
	
	# We have a schematic and the person is adding a product from it.
	# Check if this would overflow.
	max_allowed_storage_for_this_product = self.schematic.inputs[product_name]
	currently_stored_quantity = stored_products[product_name]
	
	# If it would overflow, get upset.
	if (quantity + currently_stored_quantity > max_allowed_storage_for_this_product)
	  raise ArgumentError, "Adding this much #{product_name} would overflow the storage area."
	else
	  # Add to the existing column.
	  stored_products[product_name] += quantity
	end
  end
  
  def remove_all_stored_products
	stored_products.each_key do |product_name|
	  remove_all_of_product(product_name)
	end
  end
  
  def remove_all_of_product(product_name)
	raise ArgumentError, "Schematic is not set." unless (self.schematic != nil)
	raise ArgumentError, "Named product is not part of the set Schematic." unless self.schematic.inputs.has_key?(product_name)
	
	stored_products[product_name] = 0
  end
  
  def remove_qty_of_product(product_name, quantity)
	raise ArgumentError, "Schematic is not set." unless (self.schematic != nil)
	raise ArgumentError, "Named product is not part of the set Schematic." unless self.schematic.inputs.has_key?(product_name)
	raise ArgumentError, "Named product is not stored here." unless self.stored_products.has_key?(product_name)
	
	currently_stored_quantity = stored_products[product_name]
	
	# If it would underflow, set it to zero.
	if (currently_stored_quantity - quantity < 0)
	  stored_products[product_name] = 0
	else
	  # Remove it from the column.
	  stored_products[product_name] -= quantity
	end
  end
end