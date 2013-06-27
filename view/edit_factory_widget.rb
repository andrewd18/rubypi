
require 'gtk3'
require_relative 'simple_combo_box.rb'
require_relative 'select_building_combo_box.rb'
require_relative '../model/schematic.rb'

require_relative 'simple_table.rb'
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
	input_from_label = Gtk::Label.new("Input from:")
	output_to_label = Gtk::Label.new("Output to:")
	
	# Center column.
	# Populate the combo box with the schematics this factory can accept.
	@schematic_combo_box = SimpleComboBox.new(@building_model.accepted_schematic_names)
	
	# Set the value in the combo box to the value from the model.
	@schematic_combo_box.selected_item = @building_model.schematic_name
	
	# When the user changes the schematic_combo_box, force a commit.
	@schematic_combo_box.signal_connect("changed") do |combo_box|
	  commit_to_model
	end
	
	@input_building_combo_box = SelectBuildingComboBox.new(@building_model.planet.aggregate_launchpads_ccs_storages)
	@input_building_combo_box.signal_connect("changed") do |combo_box|
	  commit_to_model
	end
	
	@output_building_combo_box = SelectBuildingComboBox.new(@building_model.planet.aggregate_launchpads_ccs_storages)
	@output_building_combo_box.signal_connect("changed") do |combo_box|
	  commit_to_model
	end
	
	
		                                # rows, columns, homogenous?
	@factory_options_table = SimpleTable.new(4, 2, false)
	
	
	# Center column
	create_sliders_for_stored_products
	
	
	# Schematic row
	@factory_options_table.attach(schematic_label, 1, 1)
	@factory_options_table.attach(@schematic_combo_box, 1, 2)
	
	# Stored Products row
	@factory_options_table.attach(stored_products_label, 2, 1)
	# Middle row, right column (2, 2) is attached as part of create_sliders_for_stored_products,
	
	# Input From: row
	@factory_options_table.attach(input_from_label, 3, 1)
	@factory_options_table.attach(@input_building_combo_box, 3, 2)
	
	# Output to row
	@factory_options_table.attach(output_to_label, 4, 1)
	@factory_options_table.attach(@output_building_combo_box, 4, 2)
	
	# By wrapping the table in a vertical box, we ensure that the vbox expands
	# and the table does not.
	factory_options_table_vbox = Gtk::Box.new(:vertical)
	factory_options_table_vbox.pack_start(@factory_options_table, :expand => false)
	
	# Finally, add a decorator frame around it.
	factory_options_table_frame = Gtk::Frame.new
	factory_options_table_frame.add(factory_options_table_vbox)
	
	
	
	
	
	
	# Right column.
	building_image = BuildingImage.new(@building_model)
	
	# By wrapping the image in a vertical box, we ensure that the vbox expands
	# and the image does not.
	building_image_column = Gtk::Box.new(:vertical)
	building_image_column.pack_start(building_image, :expand => false)
	
	# Finally, add a decorator frame around it.
	building_image_frame = Gtk::Frame.new
	building_image_frame.add(building_image_column)
	
	# Pack columns left to right.
	self.pack_start(factory_options_table_frame, :expand => true)
	self.pack_start(building_image_frame, :expand => false)
	
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
	  create_sliders_for_stored_products
	  
	  @input_building_combo_box.selected_item = @building_model.production_cycle_input_building
	  @output_building_combo_box.selected_item = @building_model.production_cycle_output_building
	end
  end
  
  def create_sliders_for_stored_products
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
	
	@factory_options_table.attach(@stored_product_table, 2, 2)
	
	# WORKAROUND
	# If I don't force a show_all on @factory_options_table here, it won't show the new columns.
	@factory_options_table.show_all
  end
  
  def commit_to_model
	# Set the model schematic to the selected value.
	@building_model.schematic_name = @schematic_combo_box.selected_item
	
	# Set the stored products to the selected value.
	@scales_hash.each_pair do |product_name, scale|
	  @building_model.stored_products[product_name] = scale.value
	end
	
	@building_model.production_cycle_input_building = @input_building_combo_box.selected_item 
	@building_model.production_cycle_output_building = @output_building_combo_box.selected_item
  end
  
  def destroy
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end