# Require Bundler if we're packing up the executable. Otherwise no.
require 'bundler/setup' unless not defined?(Ocra)

require 'gtk3'

require_relative 'view/ruby_pi_main_menu.rb'
require_relative 'view/system_view_widget.rb'
require_relative 'model/pi_configuration.rb'

require_relative 'model/product.rb'
require_relative 'model/schematic.rb'

class RubyPI < Gtk::Window
  def initialize
	super(Gtk::Window::Type::TOPLEVEL)
	
	# Make sure closing the window runs properly.
	self.signal_connect("delete_event") do
	  close_application
	end
	
	@menu_bar = RubyPIMainMenu.new
	
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
	
	
	# TODO: Allow user to load from file.
	@pi_configuration = PIConfiguration.new
	
	# HACK for testing.
	# (planet_type, planet_name = nil, planet_alias = nil, planet_buildings = Array.new, pi_configuration = nil)
	@pi_configuration.add_planet(Planet.new("Barren", "J100820 I", "Factory"))
	@pi_configuration.add_planet(Planet.new("Lava", "J100820 III", "Chiral & Silicon"))
	@pi_configuration.add_planet(Planet.new("Lava", "J100820 VII", "Metals"))
	@pi_configuration.add_planet(Planet.new("Oceanic", "J100820 VIII", "Microorganisms"))
	@pi_configuration.add_planet(Planet.new("Temperate", "J100820 IX", "Infected Sheep"))
	@pi_configuration.add_planet(Planet.new("Uncolonized"))
	
	@box = Gtk::Box.new(:vertical)
	
	@main_widget = SystemViewWidget.new(@pi_configuration)
	@box.pack_start(@menu_bar, :expand => false, :fill => false)
	@box.pack_start(@main_widget, :expand => false, :fill => false)
	
	
	self.add(@box)
	
	# Make sure all our widgets are visible.
	self.show_all
	
	return self
  end
  
  def pi_configuration
	return @pi_configuration
  end
  
  def pi_configuration=(new_pi_configuration)
	# Unhook existing widget observers.
	@main_widget.stop_observing_model
	
	@pi_configuration = new_pi_configuration
	
	# Pass new model along to child widgets.
	@main_widget.pi_configuration_model = (@pi_configuration)
	
	# Reattach existing widget observers.
	@main_widget.start_observing_model
  end
  
  def main_widget
	return @main_widget
  end
  
  def menu_bar
	return @menu_bar
  end
  
  def change_main_widget(new_widget)
	@main_widget.destroy
	@main_widget = new_widget
	@box.pack_start(@main_widget)
	
	# HACK: Attempt to resize to 1px by 1px which will get rid of any extraneous space caused by a widget size change.
	# This is a standin method until I get all the UI widgets to resize nicely to any size.
	self.resize(1,1)
	self.show_all
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
