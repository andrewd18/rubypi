require_relative 'planetary_building.rb'

class BasicIndustrialFacility < PlanetaryBuilding
  
  POWERGRID_USAGE = 800
  CPU_USAGE = 200
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 75000.00
  
  def initialize
	@powergrid_usage = POWERGRID_USAGE
	@cpu_usage = CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	
	return self
  end
  
  def name 
	return "Basic Industrial Facility"
  end
end
