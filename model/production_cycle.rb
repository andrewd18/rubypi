# Defines functions for a PlanetaryBuilding that
# - creates products on a cycle
# - exports those products
# - may import other products

# Including class must:
#  * Define a reader named "storage_volume".

module ProductionCycle
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