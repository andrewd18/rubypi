# A container class for a bunch of buttons.

require 'gtk3'

require_relative '../../model/product.rb'

class PlanetToolPalette < Gtk::Toolbar
  def initialize(controller)
	# Set up base GTK+ requirements.
	super()
	
	# Store the controller whose actions this view can use.
	@controller = controller
	
	# Configure GTK+ options for this widget.
	self.orientation=(:vertical)
	self.toolbar_style=(Gtk::Toolbar::Style::BOTH_HORIZ)
	self.show_arrow = false
	
	list_of_buttons = Array.new
	
	
	import_from_yaml_button = Gtk::ToolButton.new(:icon_widget => Gtk::Image.new(:file => "view/images/16x16/document-open.png"), :label => "Load PI Config")
	import_from_yaml_button.signal_connect("clicked") do |button|
	  self.load_from_yaml
	end
	list_of_buttons << import_from_yaml_button
	
	export_to_yaml_button = Gtk::ToolButton.new(:icon_widget => Gtk::Image.new(:file => "view/images/16x16/document-save.png"), :label => "Save PI Config")
	export_to_yaml_button.signal_connect("clicked") do |button|
	  self.save_to_yaml
	end
	list_of_buttons << export_to_yaml_button
	
	
	separator = Gtk::SeparatorToolItem.new
	list_of_buttons << separator
	
	#
	# Add the "Add <Type> Planet" buttons.
	#
	
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
	
	
	
	second_separator = Gtk::SeparatorToolItem.new
	list_of_buttons << second_separator
	
	update_eve_central_data_button = Gtk::ToolButton.new(:icon_widget => Gtk::Image.new(:file => "view/images/16x16/refresh_icon.png"), :label => "Refresh from EVE-Central")
	update_eve_central_data_button.signal_connect("clicked") do |widget, event|
		self.refresh_eve_central_data
	end
	list_of_buttons << update_eve_central_data_button
	
	list_of_buttons.each_with_index do |button, index|
	  self.insert(button, index)
	end
	
	return self
  end
  
  def refresh_eve_central_data
	seconds_in_an_hour = 3600
	
	if ((Time.now - seconds_in_an_hour) > Product.last_updated_time)
		Product.update_eve_central_values
	else
		puts "Already updated in the last hour."
	end
  end
  
  def save_to_yaml
	dialog = SaveToYamlDialog.new($ruby_pi_main_gtk_window)
	
	# Run the dialog.
	if dialog.run == Gtk::ResponseType::ACCEPT
	  # Get the filename the user gave us.
	  user_set_filename = dialog.filename
	  
	  # Append .yml to it, if necessary.
	  unless (user_set_filename.end_with?(".yml"))
		user_set_filename += ".yml"
	  end
	  
	  @controller.export_to_file(user_set_filename)
	end
	
	dialog.destroy
  end
  
  def load_from_yaml
	dialog = LoadFromYamlDialog.new($ruby_pi_main_gtk_window)
	
	# Run the dialog.
	if dialog.run == Gtk::ResponseType::ACCEPT
	  @controller.import_from_file(dialog.filename)
	end
	
	dialog.destroy
  end
end