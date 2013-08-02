
require 'observer'

require_relative 'planetary_building.rb'
require_relative 'advanced_industrial_facility.rb'
require_relative 'basic_industrial_facility.rb'
require_relative 'command_center.rb'
require_relative 'extractor.rb'
require_relative 'high_tech_industrial_facility.rb'
require_relative 'launchpad.rb'
require_relative 'storage_facility.rb'
require_relative 'planetary_link.rb'
require_relative 'customs_office.rb'

# A planet contains a series of buildings added by the user.
# A planet needs to observe all of its buildings for changes.
# A planet needs to inform things that observe it when it or any of its buildings have changed.
class Planet
  
  include Observable
  
  attr_reader :buildings
  attr_reader :links
  attr_reader :customs_office
  attr_accessor :pi_configuration
  
  PLANET_TYPES = ["Uncolonized",
                  "Gas",
                  "Ice",
                  "Storm",
                  "Barren",
                  "Temperate",
                  "Lava",
                  "Oceanic",
                  "Plasma"]
  
  PLANET_TYPES_WITHOUT_UNCOLONIZED = ["Gas",
									  "Ice",
									  "Storm",
									  "Barren",
									  "Temperate",
									  "Lava",
									  "Oceanic",
									  "Plasma"]
  
  
  def initialize(planet_type, planet_name = nil, planet_buildings = Array.new, planet_links = Array.new, customs_office = nil, pi_configuration = nil)
	@type = planet_type
	
	@name = planet_name
	
	@buildings = planet_buildings
	
	@links = planet_links
	
	@customs_office = customs_office
	
	@pi_configuration = pi_configuration
	
	return self
  end
  
  # Part of Observer.
  # Called when an observed object sends "changed".
  def update
	# One of my planetary buildings changed.
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
  end
  
  def type
	return @type
  end
  
  def type=(new_type)
	raise ArgumentError, "Error: #{new_type} is not a known planet type." unless (PLANET_TYPES.include?(new_type))
	
	# Only set it and announce if the type actually changed.
	if (@type != new_type)
	  @type = new_type
	  
	  # Tell my observers I've changed.
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	end
	
	return @type
  end
  
  def name
	return @name
  end
  
  def name=(new_name)
	raise ArgumentError, "#{new_name} is not a String." unless new_name.is_a?(String)
	
	# Only set it and announce if the name actually changed.
	if (@name != new_name)
	  @name = new_name
	  
	  # Tell my observers I've changed.
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	end
	
	return @name
  end
  
  def powergrid_usage
	total = 0
	
	# Update values from buildings.
	@buildings.each do |building|
	
	  # Update overall powergrid usage.
	  total += building.powergrid_usage
	end
	
	@links.each do |link|
	  total += link.powergrid_usage
	end
	
	return total
  end
  
  def cpu_usage
	total = 0
	
	# Update values from buildings.
	@buildings.each do |building|
	
	  # Update overall powergrid usage.
	  total += building.cpu_usage
	end
	
	@links.each do |link|
	  total += link.cpu_usage
	end
	
	return total
  end
  
  def powergrid_provided
	total = 0
	
	# Update values from buildings.
	@buildings.each do |building|
	
	  # Update overall powergrid usage.
	  total += building.powergrid_provided
	end
	
	return total
  end
  
  def cpu_provided
	total = 0
	
	# Update values from buildings.
	@buildings.each do |building|
	
	  # Update overall powergrid usage.
	  total += building.cpu_provided
	end
	
	return total
  end
  
  def pct_powergrid_usage
	# Prevent dividing by zero.
	if (self.powergrid_provided == 0)
	  return 0
	end
	
	# 100% in Float form to ensure a decimal.
	one_hundred_percent = 100.0
	
	scaled_powergrid_provided = (one_hundred_percent / self.powergrid_provided)
	percent_used = (self.powergrid_usage * scaled_powergrid_provided)
	
	return percent_used
  end
  
  def pct_cpu_usage
	# Prevent dividing by zero.
	if (self.powergrid_provided == 0)
	  return 0
	end
	
	# 100% in Float form to ensure a decimal.
	one_hundred_percent = 100.0
	
	scaled_cpu_provided = (one_hundred_percent / self.cpu_provided)
	percent_used = (self.cpu_usage * scaled_cpu_provided)
	
	return percent_used
  end
  
  def isk_cost
	total = 0
	
	# Update values from buildings.
	@buildings.each do |building|
	
	  # Update overall powergrid usage.
	  total += building.isk_cost
	end
	
	@links.each do |link|
	  total += link.isk_cost
	end
	
	return total
  end
  
  def add_building(building)
	if (building.is_a?(CustomsOffice))
	  self.add_customs_office(building)
	  return building
	end
	
	# Limit number of command centers and customs offices to 1.
	if (building.is_a?(CommandCenter) and
	    self.num_command_centers == 1)
	  raise ArgumentError, "A planet can only have one CommandCenter."
	end
	
	# Can't add anything but PlanetaryBuildings.
	raise ArgumentError unless building.is_a?(PlanetaryBuilding)
	
	# Good to go.
	@buildings << building
	building.planet=(self)
	building.add_observer(self)
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
	
	return building
  end
  
  # Convenience wrapper.
  def add_building_from_class(dat_class)
	building = dat_class.new
	self.add_building(building)
  end
  
  def remove_building(building_to_remove)
	if (building_to_remove.is_a?(CustomsOffice))
	  self.remove_customs_office
	  return
	end
	
	building_to_remove.delete_observer(self)
	building_to_remove.planet = nil
	
	# Remove any links associated with the building.
	connected_links = find_links_connected_to(building_to_remove)
	connected_links.each do |link|
	  self.remove_link(link)
	end
	
	# Remove the building.
	@buildings.delete(building_to_remove)
	
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
	
	@customs_office = nil
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
  end
  
  def add_customs_office(new_customs_office)
	# Prevent user from adding multiple customs offices.
	if (self.customs_office != nil)
	  raise ArgumentError, "A planet can only have one CustomsOffice."
	else
	  @customs_office = new_customs_office
	  
	  # Tell my observers I've changed.
	  changed # Set observeable state to "changed".
	  notify_observers() # Notify errybody.
	end
  end
  
  def remove_customs_office
	@customs_office = nil
	
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
  end
  
  def abandon
	self.remove_all_buildings
	
	@type = "Uncolonized"
	@name = nil
	
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
  
  def pocos
	if (self.customs_office != nil)
	  return [@customs_office]
	else
	  return Array.new
	end
  end
  
  def num_pocos
	if (self.customs_office != nil)
	  return 1
	else
	  return 0
	end
  end
  
  def num_aggregate_launchpads_ccs_storages
	count = 0
	
	@buildings.each do |building|
	  if ((building.class == StorageFacility) ||
	      (building.class == CommandCenter) ||
	      (building.class == Launchpad) ||
	      (building.class == CustomsOffice))
		
		count += 1
	  end
	end
	
	return count
  end
  
  def aggregate_launchpads_ccs_storages
	list_of_aggregate_storages = Array.new
	
	@buildings.each do |building|
	  if ((building.class == StorageFacility) ||
	      (building.class == CommandCenter) ||
	      (building.class == Launchpad) ||
	      (building.class == CustomsOffice))
		
		list_of_aggregate_storages << building
	  end
	end
	
	return list_of_aggregate_storages
  end
  
  # Creates a link between node a and b.
  def add_link(source_building, destination_building)
	existing_link = self.find_link(source_building, destination_building)
	
	if (existing_link == nil)
	  # Create a new link.
	  new_link = PlanetaryLink.new(self, source_building, destination_building)
	  new_link.add_observer(self)
	  
	  @links << new_link
	  
	  return new_link
	else
	  # Return the existing link.
	  return existing_link
	end
  end
  
  # Finds all links connected to the given building.
  def find_links_connected_to(building)
	connected_links = Array.new
	
	@links.each do |link|
	  if ((link.source_building == building) or
	      (link.destination_building == building))
		
		connected_links << link
	  end
	end
	
	return connected_links
  end
  
  # Finds a specific link.
  def find_link(source_building, destination_building)
	list_of_possible_matching_links = self.find_links_connected_to(source_building)
	
	list_of_possible_matching_links.each do |link|
	  if (((link.source_building == source_building) and (link.destination_building == destination_building)) or
		  ((link.source_building == destination_building) and (link.destination_building == source_building)))
		
		return link
	  end
	end
	
	return nil
  end
  
  # Removes a particular link.
  def remove_link(link_instance)
	# Remove it from our list.
	# Lean on Array.delete
	@links.delete(link_instance)
	link_instance.delete_observer(self)
  end
  
  def num_links
	return @links.count
  end
  
  def remove_planet
	# Lean on parent pi_configuration function.
	@pi_configuration.remove_planet(self)
  end
end