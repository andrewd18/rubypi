# Require Bundler if we're packing up the executable. Otherwise no.
require 'bundler/setup' unless not defined?(Ocra)

require 'gtk3'

require_relative 'view/ruby_pi_main_menu.rb'
require_relative 'view/system_view_widget.rb'
require_relative 'model/pi_configuration.rb'

require_relative 'model/product.rb'
require_relative 'model/schematic.rb'

class RubyPI < Gtk::Window
  
  attr_accessor :pi_configuration
  
  def initialize
	super(Gtk::Window::Type::TOPLEVEL)
	
	# Make sure closing the window runs properly.
	self.signal_connect("delete_event") do
	  close_application
	end
	
	# Setup the models.
	# Load static products into memory.
	products = Product.all
	if (products.empty?)
	  Product.load_from_yaml
	end
	
	# Load static schematics into memory.
	schematics = Schematic.all
	if (schematics.empty?)
	  Schematic.load_from_yaml
	end
	
	# Create a blank PI Configuration with 6 planets. User can load a different one if they feel like it.
	@pi_configuration = PIConfiguration.new
	
	# Setup the view.
	@menu_bar = RubyPIMainMenu.new
	
	@box = Gtk::Box.new(:vertical)
	@box.pack_start(@menu_bar, :expand => false, :fill => false)
	
	self.change_main_widget(SystemViewWidget.new(@pi_configuration))
	
	self.add(@box)
	
	# Make sure all our widgets are visible.
	self.show_all
	
	return self
  end
  
  def main_widget
	return @main_widget
  end
  
  def menu_bar
	return @menu_bar
  end
  
  def change_main_widget(new_widget)
	if (@main_widget)
	  @main_widget.destroy
	end
	
	@main_widget = new_widget
	@box.pack_start(@main_widget)
	
	self.show_all
	
	# Finally, tell the widget it can begin observing the model.
	@main_widget.start_observing_model
  end
  
  def close_application
	Gtk.main_quit
	exit!
  end
end


# If the Ocra class isn't defined, then run the app.
# If it is defined, we're packaging it and we don't want to run the app.
if not defined?(Ocra)
  $ruby_pi_main_gtk_window = RubyPI.new
  
  # Start the main loop for event handling.
  Gtk.main
end
