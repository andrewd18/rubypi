require_relative 'planetary_building.rb'
require_relative 'unrestricted_storage.rb'
require_relative 'linkable.rb'

class StorageFacility < PlanetaryBuilding
  
  include UnrestrictedStorage
  include Linkable
  
  POWERGRID_USAGE = 700
  CPU_USAGE = 500
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 250000.00
  STORAGE_VOLUME = 12000.0
  
  def initialize(x_pos = 0.0, y_pos = 0.0)
	@powergrid_usage = POWERGRID_USAGE
	@cpu_usage = CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	
	@x_pos = x_pos
	@y_pos = y_pos
	
	return self
  end
  
  def name
	return "Storage Facility"
  end
  
  def storage_volume
	return STORAGE_VOLUME
  end
end
