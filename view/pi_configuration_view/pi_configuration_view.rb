require 'gtk3'

require_relative 'planet_tool_palette.rb'
require_relative 'planet_list.rb'

class PIConfigurationView < Gtk::Box
  def initialize(controller)
	# Set up base GTK+ requirements.
	super(:horizontal)
	
	# Store the controller whose actions this view can use.
	@controller = controller
	
	# Set up all the widgets unique to this view. Delegate to subclasses where necessary.
	@planet_tool_palette = PlanetToolPalette.new(@controller)
	@planet_list = PlanetList.new(@controller)
	
	planet_list_scrolled_window = Gtk::ScrolledWindow.new
	planet_list_scrolled_window.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	planet_list_scrolled_window.add(@planet_list)
	
	self.pack_start(@planet_tool_palette, :expand => false)
	self.pack_start(planet_list_scrolled_window, :expand => true)
	
	self.show_all
	
	return self
  end
  
  def pi_configuration_model=(new_model)
	# Update the view using the new model for values.
	@planet_list.pi_configuration_model = new_model
  end
end