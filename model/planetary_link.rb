
class PlanetaryLink
  
  BASE_POWERGRID_USAGE = 10
  BASE_CPU_USAGE = 15
  MIN_LENGTH = 2 #km
  MAX_LENGTH = 40000 #km
  ISK_COST = 0
  UPGRADE_LEVEL = 0
  
  # TODO:
  # According to research done on Odyssey 1.0.10,
  # default transfer volume per hour is 1250 m3 per hour.
  # 
  # The value below is from http://wiki.eveuniversity.org/Planetary_Buildings#Planetary_Links
  # and is probably inaccurate.
  TRANSFER_VOLUME = 250
  
  attr_reader :planet
  attr_reader :source_building
  attr_reader :destination_building
  
  def initialize(planet, source_building, destination_building)
	# Hard coded options.
	@length = MIN_LENGTH
	@upgrade_level = UPGRADE_LEVEL
	@powergrid_usage = BASE_POWERGRID_USAGE
	@cpu_usage = BASE_CPU_USAGE
	@isk_cost = ISK_COST
	@transfer_volume = TRANSFER_VOLUME
	
	# Error checking before variables.
	raise ArgumentError, "Destination cannot be the same as source." unless (source_building != destination_building)
	
	# Variable options.
	@planet = planet
	@source_building = source_building
	@destination_building = destination_building
	
	return self
  end
  
  def length
	return @length
  end
  
  def length=(new_length)
	if ((MIN_LENGTH..MAX_LENGTH).include?(new_length))
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
  
  def isk_cost
	return @isk_cost
  end
  
  def transfer_volume
	return @transfer_volume
  end
  
  def start_x_pos
	return @source_building.x_pos
  end
  
  def start_y_pos
	return @source_building.y_pos
  end
  
  def end_x_pos
	return @destination_building.x_pos
  end
  
  def end_y_pos
	return @destination_building.y_pos
  end
end