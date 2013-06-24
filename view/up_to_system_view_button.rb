require_relative 'system_view_widget.rb'

class UpToSystemViewButton < Gtk::Button
  def initialize(parent_widget)
	
	super(:stock_id => Gtk::Stock::GO_UP)
	
	@parent_widget = parent_widget
	
	self.signal_connect("pressed") do
	  return_to_system_view
	end
  end
  
  def return_to_system_view
	# TODO: This should be a responsibility of the parent widget.
	# Tell the parent widget to commit to the model before killing itself.
	@parent_widget.commit_to_model
	
	# Get the PI configuration for this widget's planet.
	planet_model = @parent_widget.planet_model
	pi_configuration = planet_model.pi_configuration
	
	$ruby_pi_main_gtk_window.change_main_widget(SystemViewWidget.new(pi_configuration))
  end
end