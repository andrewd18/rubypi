# A container class for a bunch of buttons.

require 'gtk3'

class PlanetToolPalette < Gtk::Toolbar
  def initialize(controller)
	# Set up base GTK+ requirements.
	super()
	
	# Store the controller whose actions this view can use.
	@controller = controller
	
	# Configure GTK+ options for this widget.
	self.orientation=(:vertical)
	self.toolbar_style=(Gtk::Toolbar::Style::BOTH_HORIZ)
	
	
	#
	# Add the "Add <Type> Planet" buttons.
	#
	list_of_buttons = Array.new
	
	add_gas_planet_button = Gtk::ToolButton.new(:icon_widget => Gtk::Image.new(:file => "view/images/16x16/gas_planet.png"), :label => "Add Gas Planet")
	add_gas_planet_button.signal_connect("clicked") do |widget, event|
	  @controller.add_gas_planet
	end
	list_of_buttons << add_gas_planet_button
	
	add_ice_planet_button = Gtk::ToolButton.new(:icon_widget => Gtk::Image.new(:file => "view/images/16x16/ice_planet.png"), :label => "Add Ice Planet")
	add_ice_planet_button.signal_connect("clicked") do |widget, event|
	  @controller.add_ice_planet
	end
	list_of_buttons << add_ice_planet_button
	
	add_storm_planet_button = Gtk::ToolButton.new(:icon_widget => Gtk::Image.new(:file => "view/images/16x16/storm_planet.png"), :label => "Add Storm Planet")
	add_storm_planet_button.signal_connect("clicked") do |widget, event|
	  @controller.add_storm_planet
	end
	list_of_buttons << add_storm_planet_button
	
	add_barren_planet_button = Gtk::ToolButton.new(:icon_widget => Gtk::Image.new(:file => "view/images/16x16/barren_planet.png"), :label => "Add Barren Planet")
	add_barren_planet_button.signal_connect("clicked") do |widget, event|
	  @controller.add_barren_planet
	end
	list_of_buttons << add_barren_planet_button
	
	add_temperate_planet_button = Gtk::ToolButton.new(:icon_widget => Gtk::Image.new(:file => "view/images/16x16/temperate_planet.png"), :label => "Add Temperate Planet")
	add_temperate_planet_button.signal_connect("clicked") do |widget, event|
	  @controller.add_temperate_planet
	end
	list_of_buttons << add_temperate_planet_button
	
	add_lava_planet_button = Gtk::ToolButton.new(:icon_widget => Gtk::Image.new(:file => "view/images/16x16/lava_planet.png"), :label => "Add Lava Planet")
	add_lava_planet_button.signal_connect("clicked") do |widget, event|
	  @controller.add_lava_planet
	end
	list_of_buttons << add_lava_planet_button
	
	add_oceanic_planet_button = Gtk::ToolButton.new(:icon_widget => Gtk::Image.new(:file => "view/images/16x16/oceanic_planet.png"), :label => "Add Oceanic Planet")
	add_oceanic_planet_button.signal_connect("clicked") do |widget, event|
	  @controller.add_oceanic_planet
	end
	list_of_buttons << add_oceanic_planet_button
	
	add_plasma_planet_button = Gtk::ToolButton.new(:icon_widget => Gtk::Image.new(:file => "view/images/16x16/plasma_planet.png"), :label => "Add Plasma Planet")
	add_plasma_planet_button.signal_connect("clicked") do |widget, event|
	  @controller.add_plasma_planet
	end
	list_of_buttons << add_plasma_planet_button
	
	
	list_of_buttons.each_with_index do |button, index|
	  self.insert(button, index)
	end
	
	# And set a size request.  min_width, min_height
	self.set_size_request(1, (33 * self.children.count))
	
	return self
  end
end