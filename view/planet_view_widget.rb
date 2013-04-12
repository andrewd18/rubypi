require 'gtk3'

require_relative 'add_planetary_building_widget.rb'
require_relative 'buildings_tree_store.rb'
require_relative 'buildings_tree_view.rb'
require_relative 'planet_stats_widget.rb'
require_relative 'building_view_widget.rb'
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
	
	
	# Create the Bottom Row
	bottom_row = Gtk::Box.new(:horizontal)
	
	# Left Column
	@add_planetary_building_widget = AddPlanetaryBuildingWidget.new(@planet_model)
	planetary_building_widget_frame = Gtk::Frame.new
	planetary_building_widget_frame.add(@add_planetary_building_widget)
	bottom_row.pack_start(planetary_building_widget_frame, :expand => false)
	
	
	# Center Column
	@buildings_tree_store = BuildingsTreeStore.new(@planet_model)
	@buildings_tree_view = BuildingsTreeView.new(@buildings_tree_store)
	
	
	@edit_button = Gtk::Button.new(:stock_id => Gtk::Stock::EDIT)
	@edit_button.signal_connect("clicked") do
	  # Get the iter for the building we want to edit.
	  current_tree_selection = @buildings_tree_view.selection
	  selected_row_iter = current_tree_selection.selected
	  building_iter = selected_row_iter.get_value(0)
	  
	  # TODO - Edit specific factory ID rather than relying on these iters matching.
	  $ruby_pi_main_gtk_window.change_main_widget(BuildingViewWidget.new(@planet_model.buildings[building_iter]))
	end
	
	vertical_box = Gtk::Box.new(:vertical)
	vertical_box.pack_start(@buildings_tree_view, :expand => true, :fill => true)
	vertical_box.pack_start(@edit_button, :expand => false, :fill => false)
	
	vertical_box_frame = Gtk::Frame.new
	vertical_box_frame.add(vertical_box)
	
	bottom_row.pack_start(vertical_box_frame, :expand => true, :fill => true)
	
	# Right Column
	@show_planet_stats_widget = PlanetStatsWidget.new(@planet_model)
	planet_stats_widget_frame = Gtk::Frame.new
	planet_stats_widget_frame.add(@show_planet_stats_widget)
	bottom_row.pack_start(planet_stats_widget_frame, :expand => false)
	
	
	# Add the "edit_planet_table" to the bottom portion of self's box.
	self.pack_start(bottom_row, :expand => true)
	
	# Show everything.
	self.show_all
	
	return self
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	# Manually destroy @buildings_tree_store because it's not packed into a widget,
	# and therefore doesn't get killed with child#destroy.
	@buildings_tree_store.destroy
	
	super
  end
  
  private
  
  def return_to_system_view
	# Before we return, save the data to the model.
	@show_planet_stats_widget.commit_to_model
	
	$ruby_pi_main_gtk_window.change_main_widget(SystemViewWidget.new(@planet_model.pi_configuration))
  end
end