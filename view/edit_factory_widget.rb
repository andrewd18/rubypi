
require 'gtk3'
require_relative 'simple_combo_box.rb'
require_relative '../model/schematic.rb'

# This widget provides all the options necessary to edit a BasicIndustrialFacility, AdvancedIndustrialFacility, or HighTechIndustrialFacility.
class EditFactoryWidget < Gtk::Box
  
  attr_accessor :building_model
  
  def initialize(building_model)
	super(:vertical)
	
	# Hook up model data.
	@building_model = building_model
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	# Add planet building stats widgets in a nice grid.
	factory_stats_table = Gtk::Table.new(7, 2)
	
	# Schematic Row
	schematic_label = Gtk::Label.new("Schematic:")
	
	# Populate the combo box with the schematics this factory can accept.
	@schematic_combo_box = SimpleComboBox.new(@building_model.accepted_schematic_names)
	
	# Set the active iterater from the model data.
	# Since #update does this, call #update.
	update
	
	
	factory_stats_table.attach(schematic_label, 0, 1, 0, 1)
	factory_stats_table.attach(@schematic_combo_box, 1, 2, 0, 1)
	
	self.pack_start(factory_stats_table, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def start_observing_model
	@building_model.add_observer(self)
  end
  
  def stop_observing_model
	@building_model.delete_observer(self)
  end
  
  # Called when the building_model changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  # Set the value in the combo box to the value from the model.
	  @schematic_combo_box.selected_item = @building_model.schematic_name
	end
  end
  
  def commit_to_model
	# Stop observing so the values we want to set don't get overwritten on an #update.
	self.stop_observing_model
	
	# Ignore commit unless the user picked something legit.
	@building_model.schematic_name = @schematic_combo_box.selected_item
	
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