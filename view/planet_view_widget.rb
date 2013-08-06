require 'gtk3'

require_relative 'building_layout_widget.rb'
require_relative 'planet_stats_widget.rb'
require_relative 'poco_stats_widget.rb'
require_relative 'building_view_widget.rb'
require_relative 'up_to_system_view_button.rb'
require_relative 'edit_selected_button.rb'
require_relative 'transfer_products_button.rb'

require_relative 'gtk_helpers/clear_sort_button.rb'

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
	
	# Left column(s)
	@building_layout_widget = BuildingLayoutWidget.new(@planet_model)
	building_layout_widget_frame = Gtk::Frame.new
	building_layout_widget_frame.add(@building_layout_widget)
	bottom_row.pack_start(building_layout_widget_frame, :expand => true)
	
	# Right Column
	@planet_stats_widget = PlanetStatsWidget.new(@planet_model)
	planet_stats_widget_frame = Gtk::Frame.new
	planet_stats_widget_frame.add(@planet_stats_widget)
	
	poco_stats_widget = PocoStatsWidget.new(@planet_model.customs_office)
	
	right_column_vbox = Gtk::Box.new(:vertical)
	# Pad space between them with pixels
	right_column_vbox.spacing = 10
	right_column_vbox.add(planet_stats_widget_frame, :expand => false)
	right_column_vbox.add(poco_stats_widget, :expand => false)
	
	
	bottom_row.pack_start(right_column_vbox, :expand => false)
	
	
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
	@building_layout_widget.planet_model = (@planet_model)
	@planet_stats_widget.planet_model = (@planet_model)
  end
  
  def start_observing_model
	@planet_model.add_observer(self)
	
	# Tell children to start observing.
	@building_layout_widget.start_observing_model
	@planet_stats_widget.start_observing_model
  end
  
  def stop_observing_model
	@planet_model.delete_observer(self)
	
	# Tell children to stop observing.
	@building_layout_widget.stop_observing_model
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