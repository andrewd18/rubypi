
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
  
  attr_reader :type
  attr_reader :name
  attr_reader :buildings
  attr_reader :planet_alias
  attr_accessor :pi_configuration
  
  PLANET_TYPES = {:gas => "Gas",
                  :ice => "Ice",
                  :storm => "Storm",
                  :barren => "Barren",
                  :temperate => "Temperate",
                  :lava => "Lava",
                  :oceanic => "Oceanic",
                  :plasma => "Plasma"}
  
  def initialize(planet_type, planet_name, planet_alias = nil, planet_buildings = Array.new, pi_configuration = nil)
	if (PLANET_TYPES.has_value?(planet_type))
	  @type = planet_type
	else
	  puts "Error: #{planet_type} is not a known planet type."
	  return nil
	end
	
	@name = planet_name
	
	@planet_alias = planet_alias
	
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
  
  def add_building(building)
	@buildings << building
	building.add_observer(self)
	
	# Update values.
	update
  end
  
  # Convenience wrapper.
  def add_building_from_class_name(class_name)
	building = class_name.new
	self.add_building(building)
  end
  
  def remove_planet
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