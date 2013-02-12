
require 'gtk3'

require_relative 'system_view_planet_overview_widget.rb'
require_relative 'add_planet_dialog.rb'

# This widget is designed to show a system of planets, akin to the system view in Endless Space.
# Note: The planets included in said system won't necessarily be from the same solar system.
class SystemViewWidget < Gtk::Box
  def initialize(pi_configuration_model)
	super(:horizontal)
	
	# Hook up our model data.
	@pi_configuration_model = pi_configuration_model
	
	# Add the individual planet views.
	@pi_configuration_model.planets.each do |planet|
	  add_planet_view_overview_widget_for(planet)
	end
	
	# Add the "Add Planet" button.
	@add_planet_button = Gtk::Button.new(:label => "Add Planet")
	@add_planet_button.signal_connect("clicked") do
	  add_planet_from_dialog
	end
	self.pack_end(@add_planet_button)
	
	self.show_all
	
	return self
  end
  
  def add_planet_from_dialog
	dialog = AddPlanetDialog.new(self, @pi_configuration_model)
	
	# Run the dialog and store its return value.
	new_planet = dialog.run
	
	# Add the new planet to the model.
	@pi_configuration_model.add_planet(new_planet)
	
	# Add the new overview widget to the view.
	add_planet_view_overview_widget_for(new_planet)
  end
  
  def add_planet_view_overview_widget_for(planet)
	# Create a new overview widget for our new planet.
	widget = SystemViewPlanetOverviewWidget.new(planet)
	self.pack_start(widget)
  end
end
