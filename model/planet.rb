
require 'observer'

require_relative 'planetary_building.rb'
require_relative 'advanced_industrial_facility.rb'
require_relative 'basic_industrial_facility.rb'
require_relative 'command_center.rb'
require_relative 'extractor.rb'
require_relative 'high_tech_industrial_facility.rb'
require_relative 'launchpad.rb'
require_relative 'storage_facility.rb'

# A planet contains a series of buildings added by the user.
# A planet needs to observe all of its buildings for changes.
# A planet needs to inform things that observe it when it or any of its buildings have changed.
class Planet
  
  include Observable
  
  attr_reader :buildings
  attr_reader :cpu_usage
  attr_reader :powergrid_usage
  attr_reader :cpu_provided
  attr_reader :powergrid_provided
  attr_reader :isk_cost
  attr_accessor :pi_configuration
  
  PLANET_TYPES = {:uncolonized => "Uncolonized",
                  :gas => "Gas",
                  :ice => "Ice",
                  :storm => "Storm",
                  :barren => "Barren",
                  :temperate => "Temperate",
                  :lava => "Lava",
                  :oceanic => "Oceanic",
                  :plasma => "Plasma"}
  
  def initialize(planet_type, planet_name = nil, planet_alias = nil, planet_buildings = Array.new, pi_configuration = nil)
	@type = planet_type
	
	@name = planet_name
	
	@alias = planet_alias
	
	@buildings = planet_buildings
	
	total_values_from_buildings
	
	@pi_configuration = pi_configuration
	
	return self
  end
  
  # Part of Observer.
  # Called when an observed object sends "changed".
  def update
	# One of my planetary buildings changed.
	# Update values.
	total_values_from_buildings
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
  end
  
  def type
	return @type
  end
  
  def type=(new_type)
	if (PLANET_TYPES.has_value?(new_type))
	  @type = new_type
	else
	  raise ArgumentError, "Error: #{new_type} is not a known planet type."
	end
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
	
	return @type
  end
  
  def name
	return @name
  end
  
  def name=(new_name)
	raise ArgumentError, "#{new_name} is not a String." unless new_name.is_a?(String)
	
	@name = new_name
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
	
	return @name
  end
  
  def alias
	return @alias
  end
  
  def alias=(new_alias)
	raise ArgumentError, "#{new_alias} is not a String." unless new_alias.is_a?(String)
	
	@alias = new_alias
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
	
	return @alias
  end
  
  def add_building(building)
	@buildings << building
	building.planet=(self)
	building.add_observer(self)
	
	# Update values.
	total_values_from_buildings
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
  end
  
  # Convenience wrapper.
  def add_building_from_class(dat_class)
	building = dat_class.new
	self.add_building(building)
  end
  
  def remove_building(building_to_remove)
	building_to_remove.delete_observer(self)
	building_to_remove.planet = nil
	@buildings.delete(building_to_remove)
	
	# Update values.
	total_values_from_buildings
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
  end
  
  def remove_all_buildings
	@buildings.each do |building|
	  building.delete_observer(self)
	  building.planet = nil
	end
	
	@buildings.clear
	
	# Update values.
	total_values_from_buildings
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
  end
  
  def abandon
	self.remove_all_buildings
	
	self.type = "Uncolonized"
	self.name = nil
	self.alias = nil
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
  end
  
  def num_buildings
	return @buildings.count
  end
  
  def num_command_centers
	count = 0
	
	@buildings.each do |building|
	  if (building.class == CommandCenter)
		count += 1
	  end
	end
	
	return count
  end
  
  def command_centers
	list_of_command_centers = Array.new
	
	@buildings.each do |building|
	  if (building.class == CommandCenter)
		list_of_command_centers << building
	  end
	end
	
	return list_of_command_centers
  end
  
  def num_extractors
	count = 0
	
	@buildings.each do |building|
	  if (building.class == Extractor)
		count += 1
	  end
	end
	
	return count
  end
  
  def extractors
	list_of_extractors = Array.new
	
	@buildings.each do |building|
	  if (building.class == Extractor)
		list_of_extractors << building
	  end
	end
	
	return list_of_extractors
  end
  
  def num_factories
	count = 0
	
	@buildings.each do |building|
	  if ((building.class == BasicIndustrialFacility) ||
	      (building.class == HighTechIndustrialFacility) ||
	      (building.class == AdvancedIndustrialFacility))
		
		count += 1
	  end
	end
	
	return count
  end
  
  def factories
	list_of_factories = Array.new
	
	@buildings.each do |building|
	  if ((building.class == BasicIndustrialFacility) ||
	      (building.class == HighTechIndustrialFacility) ||
	      (building.class == AdvancedIndustrialFacility))
		list_of_factories << building
	  end
	end
	
	return list_of_factories
  end
  
  def num_launchpads
	count = 0
	
	@buildings.each do |building|
	  if (building.class == Launchpad)
		count += 1
	  end
	end
	
	return count
  end
  
  def launchpads
	list_of_launchpads = Array.new
	
	@buildings.each do |building|
	  if (building.class == Launchpad)
		list_of_launchpads << building
	  end
	end
	
	return list_of_launchpads
  end
  
  def num_storages
	count = 0
	
	@buildings.each do |building|
	  if (building.class == StorageFacility)
		count += 1
	  end
	end
	
	return count
  end
  
  def storages
	list_of_storages = Array.new
	
	@buildings.each do |building|
	  if (building.class == StorageFacility)
		list_of_storages << building
	  end
	end
	
	return list_of_storages
  end
  
  def aggregate_launchpads_ccs_storages
	list_of_aggregate_storages = Array.new
	
	@buildings.each do |building|
	  if ((building.class == StorageFacility) ||
	      (building.class == CommandCenter) ||
	      (building.class == Launchpad))
		list_of_aggregate_storages << building
	  end
	end
	
	return list_of_aggregate_storages
  end
  
  def remove_planet
	# Lean on parent pi_configuration function.
	@pi_configuration.remove_planet(self)
  end
  
  private
  
  def total_values_from_buildings
	# Reset all values.
	@powergrid_usage = 0
	@cpu_usage = 0
	@powergrid_provided = 0
	@cpu_provided = 0
	@isk_cost = 0
	
	# Update values from buildings.
	@buildings.each do |building|
	
	  # Update overall powergrid usage.
	  @powergrid_usage += building.powergrid_usage
	  
	  # Update overall powergrid provided.
	  @powergrid_provided += building.powergrid_provided
	  
	  # Update overall cpu usage.
	  @cpu_usage += building.cpu_usage
	  
	  # Update overall cpu provided.
	  @cpu_provided += building.cpu_provided
	  
	  # Update overall isk cost.
	  @isk_cost += building.isk_cost
	end
  end
end