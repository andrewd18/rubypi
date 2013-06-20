
require 'gtk3'
require_relative 'system_view_planet_overview_widget.rb'
require_relative 'system_stats_widget.rb'
require_relative 'add_planets_widget.rb'

# This widget is designed to show a system of planets, akin to the system view in Endless Space.
# Note: The planets included in said system won't necessarily be from the same solar system.
class SystemViewWidget < Gtk::Box
  def initialize(pi_configuration_model)
	super(:horizontal)
	
	# Hook up our model data.
	@pi_configuration_model = pi_configuration_model
	
	# Left column.
	# Create widgets.
	add_planets_label = Gtk::Label.new("Add Planets:")
	add_planets_widget = AddPlanetsWidget.new(@pi_configuration_model)
	
	# Pack top to bottom.
	left_column = Gtk::Box.new(:vertical)
	left_column.pack_start(add_planets_label)
	left_column.pack_start(add_planets_widget)
	
	
	# Center column.
	# Create widgets.
	@planet_overview_widgets = Array.new
	@pi_configuration_model.planets.each do |planet|
	  widget = SystemViewPlanetOverviewWidget.new(planet)
	  
	  @planet_overview_widgets << widget
	end
	
	# Pack left to right.
	center_column = Gtk::Box.new(:horizontal)
	@planet_overview_widgets.each do |widget|
	  frame = Gtk::Frame.new
	  frame.add(widget)
	  center_column.pack_start(frame)
	end
	
	
	# Right Column.
	# Create widgets.
	@system_stats_widget = SystemStatsWidget.new(@pi_configuration_model)
	
	# Pack top to bottom.
	right_column = Gtk::Box.new(:vertical)
	right_column.pack_start(@system_stats_widget)
	
	
	# Pack columns left to right.
	self.pack_start(left_column)
	self.pack_start(center_column)
	self.pack_start(right_column)
	
	return self
  end
  
  def pi_configuration_model
	return @pi_configuration_model
  end
  
  def pi_configuration_model=(new_pi_configuration)
	# Set new PI configuration model.
	@pi_configuration_model = new_pi_configuration
	
	# Give the new model to the children.
	@pi_configuration_model.planets.each_with_index do |planet, index|
	  @planet_overview_widgets[index].planet_model = planet
	end
	
	@system_stats_widget.pi_configuration_model=(@pi_configuration_model)
  end
  
  def start_observing_model
	# Start observing.
	@pi_configuration_model.add_observer(self)
	
	# Tell children to start observing.
	@planet_overview_widgets.each do |widget|
	  widget.start_observing_model
	end
	
	@system_stats_widget.start_observing_model
  end
  
  def stop_observing_model
	# Stop observing.
	@pi_configuration_model.delete_observer(self)
	
	# Tell children to stop observing.
	@planet_overview_widgets.each do |widget|
	  widget.stop_observing_model
	end
	
	@system_stats_widget.stop_observing_model
  end
  
  def update
	# Do nothing.
  end
  
  def destroy
	self.stop_observing_model
	
	@planet_overview_widgets.clear
	
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end
