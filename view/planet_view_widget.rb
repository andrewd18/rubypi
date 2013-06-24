require 'gtk3'

require_relative 'add_planetary_building_widget.rb'
require_relative 'buildings_list_store.rb'
require_relative 'buildings_tree_view.rb'
require_relative 'planet_stats_widget.rb'
require_relative 'building_view_widget.rb'
require_relative 'up_to_system_view_button.rb'
require_relative 'edit_selected_button.rb'
require_relative 'clear_sort_button.rb'

# This is a layout-only widget that contains other, planet-specific widgets.
class PlanetViewWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	# Hook up model data.
	@planet_model = planet_model
	
	# Description and up button row widgets.
	description_label = Gtk::Label.new("Planet View")
	@up_button = UpToSystemViewButton.new(self)
	
	# Pack the description and up button row widgets.
	description_and_up_button_row = Gtk::Box.new(:horizontal)
	description_and_up_button_row.pack_start(description_label, :expand => true)
	description_and_up_button_row.pack_start(@up_button, :expand => false)
	self.pack_start(description_and_up_button_row, :expand => false)
	
	
	# Create the Bottom Row
	bottom_row = Gtk::Box.new(:horizontal)
	
	# Left Column
	@add_planetary_building_widget = AddPlanetaryBuildingWidget.new(@planet_model)
	planetary_building_widget_frame = Gtk::Frame.new
	planetary_building_widget_frame.add(@add_planetary_building_widget)
	bottom_row.pack_start(planetary_building_widget_frame, :expand => false)
	
	
	# Center Column
	@buildings_tree_view = BuildingsTreeView.new(@planet_model)
	@edit_selected_button = EditSelectedButton.new(@buildings_tree_view)
	@clear_sort_button = ClearSortButton.new(@buildings_tree_view)
	
	# TODO - Determine if I need the auto_scrollbox. Attempt to reduce column width.
	# TODO - Ugly. Convert to SimpleTable or generally clean up.
	auto_scrollbox = Gtk::ScrolledWindow.new
	# Never scroll horizontally but scroll vertically if necessary.
	auto_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	auto_scrollbox.add(@buildings_tree_view)
	
	vertical_box = Gtk::Box.new(:vertical)
	vertical_box.pack_start(auto_scrollbox, :expand => true, :fill => true)
	
	button_row = Gtk::Box.new(:horizontal)
	button_row.pack_end(@clear_sort_button, :expand => false, :fill => false)
	button_row.pack_end(@edit_selected_button, :expand => false, :fill => false)
	
	vertical_box.pack_start(button_row, :expand => false, :fill => false)
	vertical_box_frame = Gtk::Frame.new
	vertical_box_frame.add(vertical_box)
	
	bottom_row.pack_start(vertical_box_frame, :expand => true, :fill => true)
	
	# Right Column
	@planet_stats_widget = PlanetStatsWidget.new(@planet_model)
	planet_stats_widget_frame = Gtk::Frame.new
	planet_stats_widget_frame.add(@planet_stats_widget)
	bottom_row.pack_start(planet_stats_widget_frame, :expand => false)
	
	
	# Add the "edit_planet_table" to the bottom portion of self's box.
	self.pack_start(bottom_row, :expand => true)
	
	# Show everything.
	self.show_all
	
	return self
  end
  
  def planet_model
	return @planet_model
  end
  
  def planet_model=(new_planet_model)
	@planet_model = new_planet_model
	
	# Pass new @planet_model along to children.
	@buildings_tree_view.planet_model = (@planet_model)
	@planet_stats_widget.planet_model = (@planet_model)
  end
  
  def start_observing_model
	@planet_model.add_observer(self)
	
	# Tell children to start observing.
	@buildings_tree_view.start_observing_model
	@planet_stats_widget.start_observing_model
  end
  
  def stop_observing_model
	@planet_model.delete_observer(self)
	
	# Tell children to stop observing.
	@buildings_tree_view.stop_observing_model
	@planet_stats_widget.stop_observing_model
  end
  
  # TODO: Ensure that each object commits as part of its destroy.
  # Going to involve some refactoring of the objects themselves.
  def commit_to_model
	# If I don't call this, the planet_stats_widget never saves the name typed into its box.
	@planet_stats_widget.commit_to_model
  end
  
  def update
	# Do nothing.
  end
  
  def destroy
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end