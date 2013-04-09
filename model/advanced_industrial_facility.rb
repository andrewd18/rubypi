require_relative 'planetary_building.rb'
require_relative 'schematic.rb'

class AdvancedIndustrialFacility < PlanetaryBuilding
  
  POWERGRID_USAGE = 700
  CPU_USAGE = 500
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 250000.00
  
  BUILDS_P_LEVELS = [2, 3]
  
  attr_reader :schematic
  
  def initialize(schematic = nil)
	@powergrid_usage = POWERGRID_USAGE
	@cpu_usage = CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	
	@schematic = schematic
	
	return self
  end
  
  def accepted_schematics
	return Schematic.where(:p_level => BUILDS_P_LEVELS)
  end
  
  def schematic=(new_schematic)
	@schematic = new_schematic
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
	
	return @schematic
  end
  
  def name
	return "Advanced Industrial Facility"
  end
end
