require_relative 'planetary_building.rb'

class ExtractorHead < PlanetaryBuilding
  
  POWERGRID_USAGE = 550
  CPU_USAGE = 110
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 0
  
  def initialize
	# Accept incoming values or use defaults.
	@powergrid_usage = POWERGRID_USAGE
	@cpu_usage = CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	
	return self
  end
  
  def name
	return "Extractor Head"
  end
end
