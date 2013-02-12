require 'gtk3'

# require_relative 'view/add_planetary_building_widget.rb'
require_relative 'view/system_view_widget.rb'
require_relative 'model/pi_configuration.rb'

class RubyPI < Gtk::Window
  def initialize
	super(Gtk::Window::Type::TOPLEVEL)
	
	# Make sure closing the window runs properly.
	self.signal_connect("delete_event") do
	  close_application
	end
	
	@pi_configuration = PIConfiguration.new
	
	# Add a tree view.
	leftmost_widget = SystemViewWidget.new(@pi_configuration)
	self.add(leftmost_widget)
	
	# Make sure all our widgets are visible.
	self.show_all
	
	return self
  end
  
  def close_application
	Gtk.main_quit
	exit!
  end
end

app = RubyPI.new

# Start the main loop for event handling.
Gtk.main
