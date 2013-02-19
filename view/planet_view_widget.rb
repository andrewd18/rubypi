
require 'gtk3'

require_relative 'add_planetary_building_widget.rb'
require_relative 'planetary_building_widget.rb'
require_relative 'planet_stats_widget.rb'
require_relative 'system_view_widget.rb'

# This widget will show a planet, its buildings, and building-related stats.
# This widget will allow the user to add and remove buildings.
# This widget will allow the user to edit specific buildings.

class PlanetViewWidget < Gtk::Box
  def initialize(planet_model)
	super(:horizontal)
	
	# Hook up model data.
	@planet_model = planet_model
	@planet_model.add_observer(self)
	
	# Create planet data widgets.
	add_planetary_building_widget = AddPlanetaryBuildingWidget.new(@planet_model)
	planetary_building_widget = PlanetaryBuildingWidget.new(@planet_model)
	show_planet_stats_widget = PlanetStatsWidget.new(@planet_model)
	
	@up_button = Gtk::Button.new(:stock_id => Gtk::Stock::GO_UP)
	@up_button.signal_connect("pressed") do
	  $ruby_pi_main_gtk_window.change_main_widget(SystemViewWidget.new(@planet_model.pi_configuration))
	end
	
	# Add planet data widgets to view.
	self.pack_start(add_planetary_building_widget)
	self.pack_start(Gtk::Separator.new(:vertical))
	self.pack_start(planetary_building_widget)
	self.pack_start(Gtk::Separator.new(:vertical))
	self.pack_start(show_planet_stats_widget)
	self.pack_start(@up_button)
	
	# Force a refresh.
	# update
	
	return self
  end
  
  def update
	# The model data changed. Update the display.
	
	
  end
end