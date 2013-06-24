require_relative 'planet_view_widget.rb'

class UpToPlanetViewButton < Gtk::Button
  def initialize(parent_widget)
	
	super(:stock_id => Gtk::Stock::GO_UP)
	
	@parent_widget = parent_widget
	
	self.signal_connect("pressed") do
	  return_to_planet_view
	end
  end
  
  def return_to_planet_view
	# Get the planet of this building_model.
	building_model = @parent_widget.building_model
	planet_model = building_model.planet
	
	$ruby_pi_main_gtk_window.change_main_widget(PlanetViewWidget.new(planet_model))
  end
end