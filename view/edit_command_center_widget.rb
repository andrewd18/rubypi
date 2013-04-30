
require 'gtk3'


# This widget provides all the options necessary to edit an Extractor.
class EditCommandCenterWidget < Gtk::Box
  
  attr_accessor :building_model
  
  def initialize(building_model)
	super(:vertical)
	
	# Hook up model data.
	@building_model = building_model
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	# Add planet building stats widgets in a nice grid.
	extractor_stats_table = Gtk::Table.new(7, 2)
	
	# Schematic Row
	upgrade_level_label = Gtk::Label.new("Upgrade Level:")
	
	# Create the spin button.						# min, max, step
	@upgrade_level_spin_button = Gtk::SpinButton.new(0, 5, 1)
	@upgrade_level_spin_button.numeric = true
	
	
	# Set the active iterater from the model data.
	# Since #update does this, call #update.
	update
	
	
	extractor_stats_table.attach(upgrade_level_label, 0, 1, 0, 1)
	extractor_stats_table.attach(@upgrade_level_spin_button, 1, 2, 0, 1)
	
	self.pack_start(extractor_stats_table, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def start_observing_model
	@building_model.add_observer(self)
  end
  
  def stop_observing_model
	@building_model.delete_observer(self)
  end
  
  # Called when the factory_model changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @upgrade_level_spin_button.value = @building_model.upgrade_level
	end
  end
  
  def commit_to_model
	# Stop observing so the values we want to set don't get overwritten on an #update.
	self.stop_observing_model
	
	upgrade_level_int = @upgrade_level_spin_button.value.to_i
	
	@building_model.set_level(upgrade_level_int)
	
	# Start observing again.
	self.start_observing_model
  end
  
  def destroy
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end