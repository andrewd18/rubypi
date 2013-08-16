require 'gtk3'

require_relative '../../model/schematic.rb'
require_relative '../common/select_building_combo_box.rb'
require_relative '../common/building_image.rb'

require_relative '../gtk_helpers/simple_combo_box.rb'
require_relative '../gtk_helpers/simple_table.rb'

# This widget provides all the options necessary to edit a BasicIndustrialFacility, AdvancedIndustrialFacility, or HighTechIndustrialFacility.
class IndustrialFacilityView < Gtk::Box
  
  def initialize(controller)
	super(:vertical)
	
	@controller = controller
	
	# Create the top row.
	# Top row should contain a label stating what view we're looking at, followed by an UP button.
	top_row = Gtk::Box.new(:horizontal)
	
	building_view_label = Gtk::Label.new("Storage Facility View")
	
	# Add our up button.
	@up_button = UpToPlanetViewButton.new(@controller)
	
	top_row.pack_start(building_view_label, :expand => true)
	top_row.pack_start(@up_button, :expand => false)
	self.pack_start(top_row, :expand => false)
	
	
	# Create the bottom row.
	# Bottom row should contain the specialized widget that lets you edit the building's model.
	bottom_row = Gtk::Box.new(:horizontal)
	
	# Create widgets.
	# Left column.
	schematic_label = Gtk::Label.new("Schematic:")
	stored_products_label = Gtk::Label.new("Stored Products:")
	input_from_label = Gtk::Label.new("Input from:")
	output_to_label = Gtk::Label.new("Output to:")
	
	# Center column.
	# Populate the combo box with the schematics this factory can accept.
	@schematic_combo_box = SimpleComboBox.new
	
	# Set up signals.
	@on_schematic_change_signal = @schematic_combo_box.signal_connect("changed") do |combo_box|
	  @controller.set_schematic_name(combo_box.selected_item)
	end
	
	@input_building_combo_box = SelectBuildingComboBox.new
	@on_input_building_change_signal = @input_building_combo_box.signal_connect("changed") do |combo_box|
	  @controller.set_input_building(combo_box.selected_item)
	end
	
	@output_building_combo_box = SelectBuildingComboBox.new
	@on_output_building_change_signal = @output_building_combo_box.signal_connect("changed") do |combo_box|
	  @controller.set_output_building(combo_box.selected_item)
	end
	
	
		                                # rows, columns, homogenous?
	@factory_options_table = SimpleTable.new(4, 2, false)
	
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
	@building_image = BuildingImage.new
	
	# By wrapping the image in a vertical box, we ensure that the vbox expands
	# and the image does not.
	building_image_column = Gtk::Box.new(:vertical)
	building_image_column.pack_start(@building_image, :expand => false)
	
	# Finally, add a decorator frame around it.
	building_image_frame = Gtk::Frame.new
	building_image_frame.add(building_image_column)
	
	# Pack columns left to right.
	bottom_row.pack_start(factory_options_table_frame, :expand => true)
	bottom_row.pack_start(building_image_frame, :expand => false)
	
	self.pack_start(bottom_row, :expand => true)
	
	self.show_all
	
	return self
  end
  
  def building_model=(new_building_model)
	@building_model = new_building_model
	
	@building_image.building_model = new_building_model
	
	# WORKAROUND
	# I wrap the view-update events in signal_handler_block(id) closures.
	# This temporarily nullifies the objects from sending GTK signal I previously hooked up.
	
	@schematic_combo_box.signal_handler_block(@on_schematic_change_signal) do
	  @schematic_combo_box.items=(@building_model.accepted_schematic_names)
	  @schematic_combo_box.selected_item = @building_model.schematic_name
	end
	
	@input_building_combo_box.signal_handler_block(@on_input_building_change_signal) do
	  @input_building_combo_box.items = (@building_model.planet.aggregate_launchpads_ccs_storages)
	  @input_building_combo_box.selected_item = @building_model.production_cycle_input_building
	end
	
	@output_building_combo_box.signal_handler_block(@on_output_building_change_signal) do
	  @output_building_combo_box.items = (@building_model.planet.aggregate_launchpads_ccs_storages)
	  @output_building_combo_box.selected_item = @building_model.production_cycle_output_building
	end
	
	create_sliders_for_stored_products
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
end