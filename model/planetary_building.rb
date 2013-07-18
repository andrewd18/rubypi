require 'observer'

# Look, kids, it's an abstract class!
class PlanetaryBuilding
  
  include Observable
  
  attr_accessor :planet
  
  # Cost and other limits.
  attr_reader :powergrid_usage
  attr_reader :cpu_usage
  attr_reader :powergrid_provided
  attr_reader :cpu_provided
  attr_reader :isk_cost
  
  # Position of the building on the planet.
  attr_accessor :x_pos
  attr_accessor :y_pos
end