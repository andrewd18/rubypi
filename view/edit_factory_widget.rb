
require 'gtk3'
require_relative 'simple_combo_box.rb'
require_relative '../model/schematic.rb'

require_relative 'stored_products_list_store.rb'
require_relative 'stored_products_tree_view.rb'

require_relative 'building_image.rb'

# This widget provides all the options necessary to edit a BasicIndustrialFacility, AdvancedIndustrialFacility, or HighTechIndustrialFacility.
class EditFactoryWidget < Gtk::Box
  
  attr_accessor :building_model
  
  def initialize(building_model)
	super(:horizontal)
	
	# Hook up model data.
	@building_model = building_model
	
	# Create widgets.
	# Left column.
	schematic_label = Gtk::Label.new("Schematic:")
	stored_products_label = Gtk::Label.new("Stored Products:")
	
	
	# Center column.
	# Populate the combo box with the schematics this factory can accept.
	@schematic_combo_box = SimpleComboBox.new(@building_model.accepted_schematic_names)
	
	# Set the value in the combo box to the value from the model.
	@schematic_combo_box.selected_item = @building_model.schematic_name
	
	# When the user changes the schematic_combo_box, force a commit.
	@schematic_combo_box.signal_connect("changed") do |combo_box|
	  commit_to_model
	end
	
	# Right column.
	building_image = BuildingImage.new(@building_model)
	
	
	
	# Pack widgets into rows.
	# Pack rows into columns.
	# Left column.
	schematic_row = Gtk::Box.new(:horizontal)
	schematic_row.pack_start(schematic_label, :expand => false)
	schematic_row.pack_start(@schematic_combo_box)
	
	@stored_products_row = Gtk::Box.new(:horizontal)
	@stored_products_row.pack_start(stored_products_label, :expand => false)
	
	rebuild_stored_product_table
	
	left_column = Gtk::Box.new(:vertical)
	left_column.pack_start(schematic_row, :expand => false)
	left_column.pack_start(@stored_products_row)
	
	
	# Right column.
	right_column = Gtk::Box.new(:vertical)
	right_column.pack_start(building_image)
	
	# Pack columns left to right.
	self.pack_start(left_column, :expand => true)
	self.pack_start(right_column, :expand => false)
	
	
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
	  rebuild_stored_product_table
	end
  end
  
  def rebuild_stored_product_table
	if (@stored_product_table)
	  @stored_product_table.destroy
	  # This automatically cleans up any packed children, namely the scales of @scales_hash.
	end
	
	# Clear out the keys of the scales hash since values are dead.
	if (@scales_hash)
	  @scales_hash.clear
	end
	
	# Table of stored products.
	@stored_product_table = Gtk::Box.new(:vertical)
	@scales_hash = Hash.new
	
	@building_model.stored_products.each_pair do |product_name, quantity|
	  product_name_label = Gtk::Label.new("#{product_name}")
	  
	  max_allowed_storage_for_this_product = @building_model.schematic.inputs[product_name]
	  product_quantity_scale = Gtk::Scale.new(:horizontal, 0, max_allowed_storage_for_this_product, 1)
	  product_quantity_scale.value = quantity
	  
	  @scales_hash[product_name] = product_quantity_scale
	  
	  new_row = Gtk::Box.new(:horizontal)
	  new_row.pack_start(product_name_label)
	  new_row.pack_start(product_quantity_scale)
	  
	  @stored_product_table.pack_start(new_row)
	end
	
	@stored_products_row.pack_start(@stored_product_table)
	@stored_products_row.show_all
  end
  
  def commit_to_model
	# Set the model schematic to the selected value.
	@building_model.schematic_name = @schematic_combo_box.selected_item
	
	# Set the stored products to the selected value.
	@scales_hash.each_pair do |product_name, scale|
	  @building_model.stored_products[product_name] = scale.value
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