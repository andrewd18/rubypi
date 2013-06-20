# Defines functions for a storage location in a building.
# Unrestricted storage means there is no restriction on types of products it can store.

# Including class must:
#  * Define a reader named "storage_volume".

require_relative 'product.rb'

module UnrestrictedStorage
  def stored_products
	# Return stored_products or a new hash.
	return @stored_products ||= Hash.new
  end
  
  def store_product(product_name, quantity)
	raise ArgumentError, "First argument must be a String." unless product_name.is_a?(String)
	raise ArgumentError, "Second argument must be a Numeric." unless quantity.is_a?(Numeric)
	raise ArgumentError, "Second argument must be greater than zero." unless (quantity > 0)
	
	# Make sure the thing we're adding exists.
	product_instance = Product.find_by_name(product_name)
	if (product_instance == nil)
	  raise ArgumentError, "Named product is not registered in Product class."
	end
	
	# Error if adding this would overflow the storage facility.
	volume_needed_for_product = (product_instance.volume * quantity)
	
	if (volume_needed_for_product > volume_available)
	  raise ArgumentError, "Adding this product would overflow the storage location."
	end
	
	
	# Ready to add!
	
	# Check to see if we already have a stack.
	# We do have it. Add to existing stack.
	if (stored_products.has_key?(product_name))
	  stored_products[product_name] += quantity
	  
	# We don't have it. Make a new stack.
	else
	  stored_products.store(product_name, quantity)
	end
	
	notify_observers_if_observable
  end
  
  def store_product_instance(product_instance, quantity)
	raise ArgumentError, "First argument must be a Product." unless product_instance.is_a?(Product)
	
	store_product(product_instance.name, quantity)
  end
  
  def remove_all_of_product(product_name)
	raise ArgumentError, "Named product is not stored here." unless stored_products.has_key?(product_name)
	
	stored_products.delete(product_name)
	
	notify_observers_if_observable
  end
  
  def remove_qty_of_product(product_name, quantity_to_remove)
	raise ArgumentError, "Named product is not stored here." unless stored_products.has_key?(product_name)
	raise ArgumentError, "Second argument must be greater than zero." unless (quantity_to_remove > 0)
	
	current_quantity_of_product = stored_products[product_name]
	
	if (quantity_to_remove >= current_quantity_of_product)
	  # Remove all of it.
	  remove_all_of_product(product_name)
	else
	  # Subtract the quantity requested.
	  stored_products[product_name] -= quantity_to_remove
	end
	
	notify_observers_if_observable
	
	return stored_products[product_name]
  end
  
  def total_volume
	return storage_volume
  end
  
  def volume_available
	return (storage_volume - volume_used)
  end
  
  def volume_used
	total_volume_used = 0
	
	stored_products.each do |product_name, quantity|
	  the_product = Product.find_by_name(product_name)
	  volume_used_for_product = (the_product.volume * quantity)
	  total_volume_used += volume_used_for_product
	end
	
	return total_volume_used
  end
  
  def notify_observers_if_observable
  	# Interact with Observable mixin, if used.
	if self.is_a?(Observable)
	  self.changed
	  self.notify_observers
	end
  end
end