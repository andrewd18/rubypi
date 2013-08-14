require 'gtk3'

class UpToPlanetViewButton < Gtk::Button
  def initialize(controller)
	
	super(:stock_id => Gtk::Stock::GO_UP)
	
	@controller = controller
	
	self.signal_connect("pressed") do
	  @controller.up_to_planet_controller
	end
	
	return self
  end
end