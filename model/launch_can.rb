require_relative 'planetary_building.rb'
require_relative 'unrestricted_storage.rb'

class LaunchCan < PlanetaryBuilding
  
  include UnrestrictedStorage
  
  POWERGRID_USAGE = 0
  CPU_USAGE = 0
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 0.00
  STORAGE_VOLUME = 500.0
  
  def initialize
	@powergrid_usage = POWERGRID_USAGE
	@cpu_usage = CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	
	return self
  end
  
  def name
	return "Launch Can"
  end
  
  def storage_volume
	return STORAGE_VOLUME
  end
end
