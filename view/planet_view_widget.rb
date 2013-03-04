
require 'gtk3'

require_relative 'add_planetary_building_widget.rb'
require_relative 'list_of_buildings_widget.rb'
require_relative 'planet_stats_widget.rb'
require_relative 'system_view_widget.rb'

# This widget will show a planet, its buildings, and building-related stats.
# This widget will allow the user to add and remove buildings.
# This widget will allow the user to edit specific buildings.

class PlanetViewWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	# Hook up model data.
	@planet_model = planet_model
	
	# Create the top row.
	top_row = Gtk::Box.new(:horizontal)
	
	planet_view_label = Gtk::Label.new("Planet View")
	
	# Add our up button.
	@up_button = Gtk::Button.new(:stock_id => Gtk::Stock::GO_UP)
	@up_button.signal_connect("pressed") do
	  return_to_system_view
	end
	
	top_row.pack_start(planet_view_label, :expand => true)
	top_row.pack_start(@up_button, :expand => false)
	self.pack_start(top_row, :expand => false)
	
	
	# Create the bottom row.
	bottom_row = Gtk::Box.new(:horizontal)
	
	# Create planet data widgets.
	@add_planetary_building_widget = AddPlanetaryBuildingWidget.new(@planet_model)
	@planetary_building_widget = ListOfBuildingsWidget.new(@planet_model)
	@show_planet_stats_widget = PlanetStatsWidget.new(@planet_model)
	
	
	# Add planet data widgets to view.
	bottom_row.pack_start(@add_planetary_building_widget, :expand => false)
	bottom_row.pack_start(@planetary_building_widget, :expand => true)
	bottom_row.pack_start(@show_planet_stats_widget, :expand => false)
	self.pack_start(bottom_row, :expand => true)
	
	return self
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
  
  private
  
  def return_to_system_view
	# Before we return, save the data to the model.
	@show_planet_stats_widget.commit_to_model
	
	$ruby_pi_main_gtk_window.change_main_widget(SystemViewWidget.new(@planet_model.pi_configuration))
  end
end