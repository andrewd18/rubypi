
require 'observer'

require_relative 'planet.rb'

class PIConfiguration
  
  include Observable
  
  attr_reader :planets
  attr_reader :product
  
  def initialize(planets = Array.new, product = nil)
	@planets = planets
	
	@planets.each do |planet|
	  planet.add_observer(self)
	end
	
	@product = product
	
	return self
  end
  
  def add_planet(new_planet)
	@planets << new_planet
  end
  
  def remove_planet(planet_to_remove)
	# Lean on Array.delete.
	@planets.delete(planet_to_remove)
  end
  
  # Part of Observer.
  # Called when an observed object sends "changed".
  def update
	# Tell my observers I've changed.
	changed # Set observeable state to "changed".
	notify_observers() # Notify errybody.
  end
end