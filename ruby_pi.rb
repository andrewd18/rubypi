require 'gtk3'

# require_relative 'view/add_planetary_building_widget.rb'
require_relative 'view/system_view_widget.rb'
require_relative 'model/pi_configuration.rb'

class RubyPI < Gtk::Window
  def initialize
	super(Gtk::Window::Type::TOPLEVEL)
	
	# Make sure closing the window runs properly.
	self.signal_connect("delete_event") do
	  close_application
	end
	
	@pi_configuration = PIConfiguration.new
	
	# Load six uncolonized planets.
	# TODO: Allow user to load from file.
	#6.times do
	  #@pi_configuration.add_planet(Planet.new("Uncolonized"))
	#end
	
	# HACK for testing.
	# (planet_type, planet_name = nil, planet_alias = nil, planet_buildings = Array.new, pi_configuration = nil)
	@pi_configuration.add_planet(Planet.new("Barren", "J100820 I", "Factory"))
	@pi_configuration.add_planet(Planet.new("Lava", "J100820 III", "Chiral & Silicon"))
	@pi_configuration.add_planet(Planet.new("Lava", "J100820 VII", "Metals"))
	@pi_configuration.add_planet(Planet.new("Oceanic", "J100820 VIII", "Microorganisms"))
	@pi_configuration.add_planet(Planet.new("Temperate", "J100820 IX", "Infected Sheep"))
	@pi_configuration.add_planet(Planet.new("Uncolonized"))
	
	vertical_layout = Gtk::Box.new(:vertical)
	
	system_view_widget = SystemViewWidget.new(@pi_configuration)
	vertical_layout.pack_start(system_view_widget)
	
	
	self.add(vertical_layout)
	
	# Make sure all our widgets are visible.
	self.show_all
	
	return self
  end
  
  def close_application
	Gtk.main_quit
	exit!
  end
end


# If the Ocra class isn't defined, then run the app.
# If it is defined, we're packaging it and we don't want to run the app.
if not defined?(Ocra)
  app = RubyPI.new
  
  # Start the main loop for event handling.
  Gtk.main
end
