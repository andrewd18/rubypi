
require 'gtk3'
require_relative 'simple_combo_box.rb'
require_relative '../model/schematic.rb'

require_relative 'stored_products_list_store.rb'
require_relative 'stored_products_tree_view.rb'

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
	
	# Set the value in the combo box to the value from the model.
	@schematic_combo_box.selected_item = @building_model.schematic_name
	
	# When the user changes the schematic_combo_box, force a commit.
	@schematic_combo_box.signal_connect("changed") do |combo_box|
	  commit_to_model
	end
	
	# Stored Products Row
	stored_products_label = Gtk::Label.new("Stored Products:")
	
	# Table of stored products.
	@stored_products_store = StoredProductsListStore.new(@building_model)
	@stored_products_store.start_observing_model
	@stored_products_list_view = StoredProductsTreeView.new(@stored_products_store)
	
	factory_stats_table.attach(schematic_label, 0, 1, 0, 1)
	factory_stats_table.attach(@schematic_combo_box, 1, 2, 0, 1)
	factory_stats_table.attach(stored_products_label, 0, 1, 1, 2)
	factory_stats_table.attach(@stored_products_list_view, 1, 2, 1, 2)
	
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
	# unless (self.destroyed?)
	# end
  end
  
  def commit_to_model
	# Set the model schematic to the selected value.
	@building_model.schematic_name = @schematic_combo_box.selected_item
  end
  
  def destroy
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	# StoredProductsListStore is not packed so it's not auto-destroyed.
	@stored_products_store.destroy
	
	super
  end
end