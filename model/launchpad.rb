require_relative 'planetary_building.rb'
require_relative 'unrestricted_storage.rb'
require_relative 'linkable.rb'

class Launchpad < PlanetaryBuilding
  
  include UnrestrictedStorage
  include Linkable
  
  POWERGRID_USAGE = 700
  CPU_USAGE = 3600
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 900000.00
  STORAGE_VOLUME = 10000.0
  
  def initialize
	@powergrid_usage = POWERGRID_USAGE
	@cpu_usage = CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	
	return self
  end
  
  def name
	return "Launchpad"
  end
  
  def storage_volume
	return STORAGE_VOLUME
  end
end
