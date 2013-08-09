require 'gtk3'

class UpToPIConfigButton < Gtk::Button
  def initialize(controller)
	
	super(:stock_id => Gtk::Stock::GO_UP)
	
	@controller = controller
	
	self.signal_connect("pressed") do
	  @controller.up_to_pi_configuration_controller
	end
  end
end