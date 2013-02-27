
require 'gtk3'

# This widget will show a planet, its buildings, and building-related stats.

class SystemStatsWidget < Gtk::Box
  def initialize(pi_configuration_model)
	super(:vertical)
	
	# Hook up model data.
	@pi_configuration_model = pi_configuration_model
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	# Add system stats widgets in a nice grid.
	system_stats_table = Gtk::Table.new(6, 2)
	
	# System Label
	@system_label = Gtk::Label.new("System")
	# Stick it in the first row, across all columns.
	system_stats_table.attach(@system_label, 0, 2, 0, 1)
	
	# System Image Row
	@system_image = Gtk::Image.new(:file => "view/images/eve_gate_128x128.png")
	# Stick it in the second row, across all columns.
	system_stats_table.attach(@system_image, 0, 2, 1, 2)
	
	self.pack_start(system_stats_table)
	
	self.show_all
	
	return self
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end