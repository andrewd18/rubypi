require_relative 'planetary_building.rb'
require_relative 'schematic.rb'
require_relative 'industrial_facility_storage.rb'
require_relative 'production_cycle.rb'
require_relative 'linkable.rb'

class HighTechIndustrialFacility < PlanetaryBuilding
  
  include IndustrialFacilityStorage
  include ProductionCycle
  include Linkable
  
  POWERGRID_USAGE = 400
  CPU_USAGE = 1100
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 525000.00
  CYCLE_TIME_IN_MINS = 60
  
  BUILDS_P_LEVELS = 4
  
  attr_reader :schematic_name
  
  def initialize(x_pos = 0.0, y_pos = 0.0, schematic_name = nil)
	@powergrid_usage = POWERGRID_USAGE
	@cpu_usage = CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	
	@schematic_name = schematic_name
	
	@x_pos = x_pos
	@y_pos = y_pos
	
	# Set the ProductionCycle time.
	self.production_cycle_time_in_minutes=(CYCLE_TIME_IN_MINS)
	
	return self
  end
  
  def schematic_name=(new_schematic_name)
	
	# Is it the same value?
	if (new_schematic_name == @schematic_name)
	  # Leave immediately but don't call our observers and don't error.
	  return @schematic_name
	  
	  
	# Is it nil?
	elsif (new_schematic_name == nil)
	  @schematic_name = nil
	  
	  # Update IndustrialFacilityStorage.
	  industrial_facility_storage_schematic_changed
	  
	  # Notify our observers that we've changed.
	  changed
	  notify_observers
	  
	  return @schematic_name
	
	
	# Okay, so it's not what we already have and it's not nil.
	# Is it a String?
	elsif (new_schematic_name.is_a?(String))
	  schematic_instance = Schematic.find_by_name(new_schematic_name)
	  
	  # Check to see if this Schematic exists.
	  if (schematic_instance == nil)
		raise ArgumentError, "A Schematic for #{new_schematic_name} does not exist."
	  end
	  
	  # Schematic exists. Check it for P-level.
	  if (schematic_instance.p_level != BUILDS_P_LEVELS)
		raise ArgumentError, "The #{new_schematic_name} Schematic is not a P-level #{BUILDS_P_LEVELS} Schematic."
	  end
	  
	  # Whew. Okay, set it.
	  @schematic_name = new_schematic_name
	  
	  # Update IndustrialFacilityStorage.
	  industrial_facility_storage_schematic_changed
	  
	  # Notify our observers that we've changed.
	  changed
	  notify_observers
	  
	  return @schematic_name
	  
	  
	# Something else?
	else
	  # Well, I don't want it so go away.
	  raise ArgumentError
	end
  end
  
  def accepted_schematic_names
	list_of_schematic_instances = Schematic.find_by_p_level(BUILDS_P_LEVELS)
	
	list_of_names = Array.new
	
	list_of_schematic_instances.each do |schematic|
	  list_of_names << schematic.name
	end
	
	return list_of_names
  end
  
  def schematic
	return Schematic.find_by_name(@schematic_name)
  end
  
  # Quick alias for tree view.
  def produces_product_name
	return @schematic_name
  end
  
  def name
	return "High Tech Industrial Facility"
  end
  
  def cycle_time
	return CYCLE_TIME_IN_MINS
  end
  
  def cycle_time_in_minutes
	return CYCLE_TIME_IN_MINS
  end
  
  def cycle_time_in_hours
	return (CYCLE_TIME_IN_MINS / 60)
  end
  
  def cycle_time_in_days
	return (self.cycle_time_in_hours / 24.0)
  end
  
  def input_products_per_cycle
	if (self.schematic != nil)
	  return schematic.inputs
	else
	  return {}
	end
  end
  
  def input_products_per_hour
	products_per_hour = {}
	
	self.input_products_per_cycle.each_pair do |product_name, quantity|
	  products_per_hour[product_name] = (quantity / self.cycle_time_in_hours)
	end
	
	return products_per_hour
  end
  
  def output_products_per_cycle
	if (self.schematic != nil)
	  return schematic.outputs
	else
	  return {}
	end
  end
  
  def output_products_per_hour
	products_per_hour = {}
	
	self.output_products_per_cycle.each_pair do |product_name, quantity|
	  products_per_hour[product_name] = (quantity / self.cycle_time_in_hours)
	end
	
	return products_per_hour
  end
end
