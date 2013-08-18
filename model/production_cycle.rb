# Defines functions for a PlanetaryBuilding that
# - creates products on a cycle
# - exports those products
# - may import other products

# Including class should (but is not required to)
#  - set its production_cycle_time_in_minutes upon instantiation.

module ProductionCycle
  # Input Buildings
  def production_cycle_input_building
	return @production_cycle_input_building
  end
  
  def production_cycle_input_building=(new_input_building)
	if ((new_input_building.nil?) or
		(new_input_building.respond_to?("remove_qty_of_product")))
	  
	  @production_cycle_input_building = new_input_building
	  
	  if (self.is_a?(Observable))
		changed
		notify_observers
	  end
	else
	   raise ArgumentError
	end
  end
  
  
  
  # Output Building
  def production_cycle_output_building
	return @production_cycle_output_building
  end
  
  def production_cycle_output_building=(new_output_building)
	if ((new_output_building.nil?) or
		(new_output_building.respond_to?("store_product")))
	  
	  @production_cycle_output_building = new_output_building
	  
	  if (self.is_a?(Observable))
		changed
		notify_observers
	  end
	else
	   raise ArgumentError
	end
  end
  
  
  
  # Cycle Time
  def production_cycle_time_in_minutes
	# Return native amount.
	return @production_cycle_time
  end
  
  def production_cycle_time_in_minutes=(new_cycle_time)
	raise ArgumentError unless (new_cycle_time.is_a?(Numeric))
	
	@production_cycle_time = new_cycle_time
  end
  
  def production_cycle_time_in_hours
	# Return stored cycle time divided by 60 minutes.
	return (@production_cycle_time / 60.0)
  end
  
  def production_cycle_time_in_hours=(new_cycle_time)
	raise ArgumentError unless (new_cycle_time.is_a?(Numeric))
	
	@production_cycle_time = (new_cycle_time * 60.0)
  end
  
  def production_cycle_time_in_days
	# Return stored cycle time divided by 1440 minutes.
	return (@production_cycle_time / 1440.0)
  end
  
  def production_cycle_time_in_days=(new_cycle_time)
	raise ArgumentError unless (new_cycle_time.is_a?(Numeric))
	
	@production_cycle_time = (new_cycle_time * 1440.0)
  end
end