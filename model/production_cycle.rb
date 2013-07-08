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
	  
	  # Delete the old planetary link.
	  if (self.input_link)
		self.planet.remove_link(self.input_link)
	  end
	  
	  # Create the new association.
	  @production_cycle_input_building = new_input_building
	  
	  # Create the new planetary link.
	  self.planet.find_or_create_link(@production_cycle_input_building, self)
	else
	   raise ArgumentError
	end
  end
  
  def input_link
	# An input link is a link that connects our input building to ourselves.
	start_node = @production_cycle_input_building
	end_node = self
	
	return self.planet.find_link(start_node, end_node)
  end
  
  
  
  # Output Building
  def production_cycle_output_building
	return @production_cycle_output_building
  end
  
  def production_cycle_output_building=(new_output_building)
	if ((new_output_building.nil?) or
		(new_output_building.respond_to?("store_product")))
	  
	  # Delete the old planetary link.
	  if (self.output_link)
		self.planet.remove_link(self.output_link)
	  end
	  
	  # Create the association.
	  @production_cycle_output_building = new_output_building
	  
	  # Create the new planetary link.
	  self.planet.find_or_create_link(self, @production_cycle_output_building)
	else
	   raise ArgumentError
	end
  end
  
  def output_link
	# An output link is a link that connects ourselves to our output building.
	start_node = self
	end_node = @production_cycle_output_building
	
	return self.planet.find_link(start_node, end_node)
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