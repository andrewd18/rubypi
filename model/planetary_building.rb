require 'observer'

# Look, kids, it's an abstract class!
class PlanetaryBuilding
  
  include Observable
  
  attr_reader :powergrid_usage
  attr_reader :cpu_usage
  attr_reader :powergrid_provided
  attr_reader :cpu_provided
  attr_reader :isk_cost
end