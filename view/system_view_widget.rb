
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
	add_planets_widget = AddPlanetsWidget.new(@pi_configuration_model)
	self.pack_start(add_planets_widget)
	
	
	
	
	
	
	@planet_overview_widgets = Array.new
	
	@pi_configuration_model.planets.each do |planet|
	  widget = SystemViewPlanetOverviewWidget.new(planet)
	  
	  @planet_overview_widgets << widget
	  
	  frame = Gtk::Frame.new
	  frame.add(widget)
	  self.pack_start(frame)
	end
	
	@system_stats_widget = SystemStatsWidget.new(@pi_configuration_model)
	self.pack_start(@system_stats_widget)
	
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
