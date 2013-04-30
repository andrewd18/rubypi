
require 'gtk3'
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
	@schematic_combo_box = Gtk::ComboBoxText.new
	@building_model.accepted_schematic_names.each do |name|
	  @schematic_combo_box.append_text(name)
	end
	
	
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
	  # Set the active schematic combo box iterator to the model's schematic.
	  if (@building_model.schematic_name == nil)
		@schematic_combo_box.active_iter=(nil)
	  else
		# Find the iter that corresponds to the model's schematic.
		@schematic_combo_box.model.each do |model, path, iter|
		  if (@building_model.schematic_name == iter.get_value(0))
			@schematic_combo_box.active_iter=(iter)
		  end
		end
	  end
	end
  end
  
  def commit_to_model
	# Stop observing so the values we want to set don't get overwritten on an #update.
	self.stop_observing_model
	
	# Ignore commit unless the user picked something legit.
	if (@schematic_combo_box.active_iter == nil)
	  return
	else
	  currently_selected_schematic_name = @schematic_combo_box.active_iter.get_value(0)
	  
	  # Find the schematic that corresponds to the active iterator.
	  @building_model.accepted_schematic_names.each do |name|
		if (name == currently_selected_schematic_name)
		  @building_model.schematic_name = name
		end
	  end
	end
	
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