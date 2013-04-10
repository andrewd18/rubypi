
require 'gtk3'

require_relative 'add_planetary_building_widget.rb'
# require_relative 'list_of_buildings_widget.rb'
require_relative 'extractor_list_widget.rb'
require_relative 'factory_list_widget.rb'
require_relative 'storage_list_widget.rb'
require_relative 'planet_stats_widget.rb'
require_relative 'system_view_widget.rb'

# This is a layout-only widget that contains other, planet-specific widgets.
class PlanetViewWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	# Hook up model data.
	@planet_model = planet_model
	
	# Create the menu and up button row.
	menu_and_up_button_row = Gtk::Box.new(:horizontal)
	
	planet_view_label = Gtk::Label.new("Planet View")
	
	# Add our up button.
	# TODO - Push this behavior out of this widget and into a "up to system view button".
	#        "UpToSystemViewButton.new" should be the only thing I call.
	@up_button = Gtk::Button.new(:stock_id => Gtk::Stock::GO_UP)
	@up_button.signal_connect("pressed") do
	  return_to_system_view
	end
	
	menu_and_up_button_row.pack_start(planet_view_label, :expand => true)
	menu_and_up_button_row.pack_start(@up_button, :expand => false)
	self.pack_start(menu_and_up_button_row, :expand => false)
	
	
	# Create the widget bottom portion of the screen, which is a giant table.
	#
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	edit_planet_table = Gtk::Table.new(3, 4)
	
	# Left Column
	@add_planetary_building_widget = AddPlanetaryBuildingWidget.new(@planet_model)
	edit_planet_table.attach(@add_planetary_building_widget, 0, 1, 0, 3)  # rows and columns indexed from zero
	
	# Center Column
	@poco_widget = Gtk::Label.new("TODO: POCO Widget")
	@extractor_list_widget = ExtractorListWidget.new(@planet_model)
	@factory_list_widget = FactoryListWidget.new(@planet_model)
	@storage_list_widget = StorageListWidget.new(@planet_model)
	
	# Stretch poco widget across columns 2 and 3
	edit_planet_table.attach(@poco_widget, 1, 3, 0, 1)  # rows and columns indexed from zero
	
	edit_planet_table.attach(@storage_list_widget, 1, 2, 1, 2)  # rows and columns indexed from zero
	edit_planet_table.attach(@extractor_list_widget, 1, 2, 2, 3)  # rows and columns indexed from zero
	edit_planet_table.attach(@factory_list_widget, 2, 3, 1, 3)  # rows and columns indexed from zero
	
	
	# Right Column
	@show_planet_stats_widget = PlanetStatsWidget.new(@planet_model)
	
	edit_planet_table.attach(@show_planet_stats_widget, 3, 4, 0, 3)  # rows and columns indexed from zero
	
	
	# Add the "edit_planet_table" to the bottom portion of self's box.
	self.pack_start(edit_planet_table, :expand => true)
	
	# Show everything.
	self.show_all
	
	return self
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
  
  private
  
  def return_to_system_view
	# Before we return, save the data to the model.
	@show_planet_stats_widget.commit_to_model
	
	$ruby_pi_main_gtk_window.change_main_widget(SystemViewWidget.new(@planet_model.pi_configuration))
  end
end