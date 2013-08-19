
class PlanetaryLink
  
  BASE_POWERGRID_USAGE = 10
  BASE_CPU_USAGE = 15
  MIN_LENGTH = 2 #km
  MAX_LENGTH = 40000 #km
  ISK_COST = 0
  UPGRADE_LEVEL = 0
  LEVEL_TO_TRANSFER_VOLUME = {0 => 1250,
                              1 => 2500,
                              2 => 5000, 
                              3 => 10000,
                              4 => 20000,
                              5 => 40000,
                              6 => 80000,
                              7 => 160000,
                              8 => 320000,
                              9 => 640000,
                              10 => 1280000}
  
  include Observable
  
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
	  
	  # Tell my observers I've changed.
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	end
  end
  
  def upgrade_level
	return @upgrade_level
  end
  
  def upgrade_level=(new_upgrade_level)
	if @upgrade_level == new_upgrade_level
	  return
	end
	
	if ((0..10).include?(new_upgrade_level))
	  @upgrade_level = new_upgrade_level
	  
	  # Tell my observers I've changed.
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	end
  end
  
  def increase_level
	if (@upgrade_level == 10)
	  return
	else
	  @upgrade_level += 1
	  
	  # Tell my observers I've changed.
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	end
  end
  
  def decrease_level
	if (@upgrade_level == 0)
	  return
	else
	  @upgrade_level -= 1
	  
	  # Tell my observers I've changed.
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	end
  end
  
  def powergrid_usage
	length_pg_usage = (@length * 0.15)
	level_pg_usage = (BASE_POWERGRID_USAGE * @upgrade_level * 1.2)
	
	total_pg_usage = (BASE_POWERGRID_USAGE + length_pg_usage + level_pg_usage)
	truncated_to_nearest_int = total_pg_usage.to_int
	
	return truncated_to_nearest_int
  end
  
  def cpu_usage
	length_cpu_usage = (@length * 0.20)
	level_cpu_usage = (BASE_CPU_USAGE * @upgrade_level * 1.4)
	
	total_cpu_usage = (BASE_CPU_USAGE + length_cpu_usage + level_cpu_usage)
	truncated_to_nearest_int = total_cpu_usage.to_int
	
	return truncated_to_nearest_int
  end
  
  def isk_cost
	return @isk_cost
  end
  
  def transfer_volume
	return LEVEL_TO_TRANSFER_VOLUME[@upgrade_level]
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