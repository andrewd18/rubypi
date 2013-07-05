require_relative 'planetary_building.rb'

class PlanetaryLink < PlanetaryBuilding
  
  BASE_POWERGRID_USAGE = 10
  BASE_CPU_USAGE = 15
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 0
  BASE_LENGTH = 2
  UPGRADE_LEVEL = 0
  
  # TODO:
  # According to research done on Odyssey 1.0.10,
  # default transfer volume per hour is 1250 m3 per hour.
  # 
  # The value below is from http://wiki.eveuniversity.org/Planetary_Buildings#Planetary_Links
  # and is probably inaccurate.
  TRANSFER_VOLUME = 250
  
  
  def initialize
	@length = BASE_LENGTH
	@upgrade_level = UPGRADE_LEVEL
	@powergrid_usage = BASE_POWERGRID_USAGE
	@cpu_usage = BASE_CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	@transfer_volume = TRANSFER_VOLUME
	
	return self
  end
  
  def length
	return @length
  end
  
  def length=(new_length)
	if ((2..40000).include?(new_length))
	  @length = new_length
	end
  end
  
  def upgrade_level
	return @upgrade_level
  end
  
  def upgrade_level=(new_upgrade_level)
	if ((0..10).include?(new_upgrade_level))
	  @upgrade_level = new_upgrade_level
	end
  end
  
  def increase_level
	if (@upgrade_level == 10)
	  return
	else
	  @upgrade_level += 1
	end
  end
  
  def decrease_level
	if (@upgrade_level == 0)
	  return
	else
	  @upgrade_level -= 1
	end
  end
  
  def powergrid_usage
	scaled_powergrid_usage = ((@length * 0.15) + BASE_POWERGRID_USAGE)
	truncated_to_nearest_int = scaled_powergrid_usage.to_int
	
	return truncated_to_nearest_int
  end
  
  def cpu_usage
	scaled_cpu_usage = ((@length * 0.20) + BASE_CPU_USAGE)
	truncated_to_nearest_int = scaled_cpu_usage.to_int
	
	return truncated_to_nearest_int
  end
  
  def powergrid_provided
	return @powergrid_provided
  end
  
  def cpu_provided
	return @cpu_provided
  end
  
  def isk_cost
	return @isk_cost
  end
  
  def transfer_volume
	return @transfer_volume
  end
end