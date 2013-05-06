require_relative 'planetary_building.rb'
require_relative 'product.rb'

class CommandCenter < PlanetaryBuilding
  
  attr_reader :upgrade_level
  attr_reader :stored_products
  
  LEVEL_TO_PG_TABLE = {"0" => 6000,
                       "1" => 9000,
                       "2" => 12000,
                       "3" => 15000,
                       "4" => 17000,
                       "5" => 19000 }
  
  LEVEL_TO_CPU_TABLE = {"0" => 1675,
                        "1" => 7057,
                        "2" => 12136,
                        "3" => 17215,
                        "4" => 21315,
                        "5" => 25415 }
  
  LEVEL_TO_ISK_TABLE = {"0" => 90000,
                        "1" => 670000,
                        "2" => 1600000,
                        "3" => 2800000,
                        "4" => 4300000,
                        "5" => 6400000 }
  
  UPGRADE_LEVEL = 0
  POWERGRID_USAGE = 0
  CPU_USAGE = 0
  
  STORAGE_VOLUME = 500.0
  
  def initialize
	@upgrade_level = UPGRADE_LEVEL
	@powergrid_usage = POWERGRID_USAGE
	@cpu_usage = CPU_USAGE
	@powergrid_provided = self.powergrid_provided
	@cpu_provided = self.cpu_provided
	@isk_cost = self.isk_cost
	
	@stored_products = Hash.new
	
	return self
  end
  
  def name 
	return "Command Center"
  end
  
  def powergrid_provided
	return LEVEL_TO_PG_TABLE["#{@upgrade_level}"]
  end
  
  def cpu_provided
	return LEVEL_TO_CPU_TABLE["#{@upgrade_level}"]
  end
  
  def isk_cost
	return LEVEL_TO_ISK_TABLE["#{@upgrade_level}"]
  end
  
  def increase_level
	if (@upgrade_level == 5)
	  # Do nothing.
	else
	  @upgrade_level += 1
	  
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	end
  end
  
  def decrease_level
	if (@upgrade_level == 0)
	  # Do nothing.
	else
	  @upgrade_level -= 1
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	end
  end
  
  def set_level(level)
	if (level.between?(0, 5))
	  # Ok, it's a valid level.
	  # Let's make sure we're not setting something we already have.
	  if (level == @upgrade_level)
		# No change in the value.
		return
	  end
	  
	  @upgrade_level = level
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	else
	  # Invalid level passed.
	  raise ArgumentError, "Passed in level must be between 0 and 5."
	end
  end
  
  # Storage related functions
  
  def store_product(product_name, quantity)
	raise ArgumentError, "First argument must be a String." unless product_name.is_a?(String)
	raise ArgumentError, "Second argument must be a Numeric." unless quantity.is_a?(Numeric)
	
	# Make sure the thing we're adding exists.
	product_instance = Product.find_by_name(product_name)
	if (product_instance == nil)
	  raise ArgumentError, "Named product is not registered in Product class."
	end
	
	# Error if adding this would overflow the command center.
	volume_needed_for_product = (product_instance.volume * quantity)
	
	if (volume_needed_for_product > self.volume_available)
	  raise ArgumentError, "Adding this product would overflow the command center."
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
