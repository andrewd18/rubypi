
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
	@pi_configuration_model.add_observer(self)
	
	@pi_configuration_model.planets.each do |planet|
	  add_planet_overview_widget(planet)
	end
	
	# create_add_planet_button
	
	return self
  end
  
  # Called when the PI model changes.
  def update
	# Let the planet views take care of themselves.
  end
  
  def add_planet_overview_widget(planet)
	# Create a new view widget from that planet.
	widget = SystemViewPlanetOverviewWidget.new(planet)
	self.pack_start(widget)
  end
  
  def add_planet_from_dialog
	dialog = AddPlanetDialog.new(@pi_configuration_model)
	
	# Run the dialog and store its return value.
	new_planet = dialog.run
	
	if (new_planet != nil)
	  # Create a new view widget from that planet.
	  widget = SystemViewPlanetOverviewWidget.new(new_planet)
	  self.pack_start(widget)
	end
  end
  
  private
  
  def create_add_planet_button
	# Add the "Add Planet" button.
	add_planet_button = Gtk::Button.new(:label => "Add Planet")
	add_planet_button.signal_connect("clicked") do
	  add_planet_from_dialog
	end
	self.pack_end(add_planet_button)
  end
end
