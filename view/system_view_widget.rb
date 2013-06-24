
require 'gtk3'
require_relative 'add_planets_widget.rb'
require_relative 'system_view_planets_list_view.rb'
require_relative 'system_stats_widget.rb'
require_relative 'planet_view_widget.rb'
require_relative 'edit_selected_button.rb'
require_relative 'clear_sort_button.rb'

# This widget is designed to show a system of planets, akin to the system view in Endless Space.
# Note: The planets included in said system won't necessarily be from the same solar system.
class SystemViewWidget < Gtk::Box
  def initialize(pi_configuration_model)
	super(:horizontal)
	
	# Hook up our model data.
	@pi_configuration_model = pi_configuration_model
	
	# Left column.
	# Create widgets.
	add_planets_label = Gtk::Label.new("Add Planets")
	add_planets_widget = AddPlanetsWidget.new(@pi_configuration_model)
	
	# Pack top to bottom.
	left_column = Gtk::Box.new(:vertical)
	left_column.pack_start(add_planets_label, :expand => false)
	left_column.pack_start(add_planets_widget)
	left_column_frame = Gtk::Frame.new
	left_column_frame.add(left_column)
	
	
	# Center column.
	# Create widgets.
	colonized_planets_label = Gtk::Label.new("Colonized Planets")
	@system_view_planets_list_view = SystemViewPlanetsListView.new(@pi_configuration_model)
	@edit_selected_button = EditSelectedButton.new(@system_view_planets_list_view)
	@clear_sort_button = ClearSortButton.new(@system_view_planets_list_view)
	
	# Pack top to bottom.
	center_column = Gtk::Box.new(:vertical)
	center_column.pack_start(colonized_planets_label, :expand => false)
	center_column.pack_start(@system_view_planets_list_view)
	
	button_row = Gtk::Box.new(:horizontal)
	button_row.pack_end(@clear_sort_button, :expand => false)
	button_row.pack_end(@edit_selected_button, :expand => false)
	
	center_column.pack_end(button_row, :expand => false)
	center_column_frame = Gtk::Frame.new
	center_column_frame.add(center_column)
	
	
	# Right Column.
	# Create widgets.
	@system_stats_widget = SystemStatsWidget.new(@pi_configuration_model)
	
	# Pack top to bottom.
	right_column = Gtk::Box.new(:vertical)
	right_column.pack_start(@system_stats_widget)
	right_column_frame = Gtk::Frame.new
	right_column_frame.add(right_column)
	
	# Pack columns left to right.
	self.pack_start(left_column_frame, :expand => false)
	self.pack_start(center_column_frame, :expand => true)
	self.pack_start(right_column_frame, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def pi_configuration_model
	return @pi_configuration_model
  end
  
  def pi_configuration_model=(new_pi_configuration)
	# Set new PI configuration model.
	@pi_configuration_model = new_pi_configuration
	
	# Give new PI model to the children.
	@system_view_planets_list_view.pi_configuration_model=(@pi_configuration_model)
	
	@system_stats_widget.pi_configuration_model=(@pi_configuration_model)
  end
  
  def start_observing_model
	# Start observing.
	@pi_configuration_model.add_observer(self)
	
	# Tell children to start observing.
	@system_view_planets_list_view.start_observing_model
	
	@system_stats_widget.start_observing_model
  end
  
  def stop_observing_model
	# Stop observing.
	@pi_configuration_model.delete_observer(self)
	
	# Tell children to stop observing.
	@system_view_planets_list_view.stop_observing_model
	
	@system_stats_widget.stop_observing_model
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
