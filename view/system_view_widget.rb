
require 'gtk3'

require_relative 'system_view_planet_overview_widget.rb'

# This widget is designed to show a system of planets, akin to the system view in Endless Space.
# Note: The planets included in said system won't necessarily be from the same solar system.
class SystemViewWidget < Gtk::Box
  def initialize(pi_configuration_model)
	super(:horizontal)
	
	# Hook up our model data.
	@pi_configuration_model = pi_configuration_model
	@pi_configuration_model.add_observer(self)
	
	@pi_configuration_model.planets.each do |planet|
	  widget = SystemViewPlanetOverviewWidget.new(planet)
	  self.pack_start(widget)
	end
	
	return self
  end
  
  # Called when the PI model changes.
  def update
	# Let the planet views take care of themselves.
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	@pi_configuration_model.delete_observer(self)
	
	super
  end
end
