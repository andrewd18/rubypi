
require 'gtk3'

# This widget will show a planet, its buildings, and building-related stats.

class SystemStatsWidget < Gtk::Box
  
  attr_accessor :pi_configuration_model
  
  def initialize(pi_configuration_model)
	super(:vertical)
	
	# Hook up model data.
	@pi_configuration_model = pi_configuration_model
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	# Add system stats widgets in a nice grid.
	system_stats_table = Gtk::Table.new(3, 2)
	
	# System Label
	@system_label = Gtk::Label.new("System")
	# Stick it in the first row, across all columns.
	system_stats_table.attach(@system_label, 0, 2, 0, 1)
	
	# System Image Row
	@system_image = Gtk::Image.new(:file => "view/images/eve_gate_128x128.png")
	# Stick it in the second row, across all columns.
	system_stats_table.attach(@system_image, 0, 2, 1, 2)
	
	# Begin semi-useful statistics.
	# Number of colonized planets / total planets.
	system_stats_table.attach(Gtk::Label.new("Colonized Planets: "), 0, 1, 2, 3)
	@num_colonized_planets = Gtk::Label.new("#{pi_configuration_model.num_colonized_planets}")
	system_stats_table.attach(@num_colonized_planets, 1, 2, 2, 3)
	
	
	self.pack_start(system_stats_table, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def start_observing_model
	@pi_configuration_model.add_observer(self)
  end
  
  def stop_observing_model
	@pi_configuration_model.delete_observer(self)
  end
  
  # Called when the PI Configuration changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @num_colonized_planets.text = "#{pi_configuration_model.num_colonized_planets} / #{pi_configuration_model.num_planets}"
	end
  end
  
  def destroy
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end