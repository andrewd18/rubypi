require 'gtk3'

require_relative '../../model/schematic.rb'
require_relative '../common/select_building_combo_box.rb'
require_relative '../common/building_image.rb'
require_relative '../common/stored_products_widget.rb'

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
	
	# Input Building
	input_building_label = Gtk::Label.new("Input Building")
	@input_building_combo_box = SelectBuildingComboBox.new
	@input_building_image = BuildingImage.new
	@input_building_stored_products_widget = StoredProductsWidget.new(@controller)
	input_building_vbox = Gtk::Box.new(:vertical)
	input_building_vbox.pack_start(input_building_label, :expand => false)
	input_building_vbox.pack_start(@input_building_combo_box, :expand => false)
	input_building_vbox.pack_start(@input_building_image, :expand => false)
	input_building_vbox.pack_start(@input_building_stored_products_widget, :expand => true)
	input_building_frame = Gtk::Frame.new
	input_building_frame.add(input_building_vbox)
	
	schematic_label = Gtk::Label.new("Schematic")
	@schematic_combo_box = SimpleComboBox.new
	@factory_building_image = BuildingImage.new
	stored_products_label = Gtk::Label.new("Stored Products")
	@stored_products_table = SimpleTable.new(3, 2)
	@stored_products_vbox = Gtk::Box.new(:vertical)
	@stored_products_vbox.pack_start(schematic_label, :expand => false)
	@stored_products_vbox.pack_start(@schematic_combo_box, :expand => false)
	@stored_products_vbox.pack_start(@factory_building_image, :expand => false)
	@stored_products_vbox.pack_start(stored_products_label, :expand => false)
	@stored_products_vbox.pack_start(@stored_products_table, :expand => false)
	stored_producs_frame = Gtk::Frame.new
	stored_producs_frame.add(@stored_products_vbox)
	
	
	output_building_label = Gtk::Label.new("Output Building")
	@output_building_combo_box = SelectBuildingComboBox.new
	@output_building_image = BuildingImage.new
	@output_building_stored_products_widget = StoredProductsWidget.new(@controller)
	
	output_building_vbox = Gtk::Box.new(:vertical)
	output_building_vbox.pack_start(output_building_label, :expand => false)
	output_building_vbox.pack_start(@output_building_combo_box, :expand => false)
	output_building_vbox.pack_start(@output_building_image, :expand => false)
	output_building_vbox.pack_start(@output_building_stored_products_widget, :expand => true)
	output_building_frame = Gtk::Frame.new
	output_building_frame.add(output_building_vbox)
	
	# Set up signals.
	@on_schematic_change_signal = @schematic_combo_box.signal_connect("changed") do |combo_box|
	  @controller.set_schematic_name(combo_box.selected_item)
	end
	
	@on_input_building_change_signal = @input_building_combo_box.signal_connect("changed") do |combo_box|
	  @controller.set_input_building(combo_box.selected_item)
	end
	
	@on_output_building_change_signal = @output_building_combo_box.signal_connect("changed") do |combo_box|
	  @controller.set_output_building(combo_box.selected_item)
	end
	
	# Pack columns left to right.
	bottom_row.pack_start(input_building_frame, :expand => false)
	bottom_row.pack_start(stored_producs_frame, :expand => true)
	bottom_row.pack_start(output_building_frame, :expand => false)
	
	self.pack_start(bottom_row, :expand => true)
	
	self.show_all
	
	return self
  end
  
  def building_model=(new_building_model)
	@building_model = new_building_model
	
	# Change images.
	@factory_building_image.building_model = new_building_model
	
	unless (@building_model.production_cycle_input_building == nil)
	  @input_building_image.building_model = @building_model.production_cycle_input_building
	end
	
	unless (@building_model.production_cycle_output_building == nil)
	  @output_building_image.building_model = @building_model.production_cycle_output_building
	end
	
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
	if (@scales_hash)
	  @stored_products_table.children.each do |child_widget|
		child_widget.destroy
	  end
	  
	  # Clear out the keys of the scales hash since values are dead.
	  @scales_hash.clear
	end
	
	@scales_hash = Hash.new
	
	table_row_iter = 1
	@building_model.stored_products.each_pair do |product_name, quantity|
	  product_name_label = Gtk::Label.new("#{product_name}")
	  
	  max_allowed_storage_for_this_product = @building_model.schematic.inputs[product_name]
	  product_quantity_scale = Gtk::Scale.new(:horizontal, 0, max_allowed_storage_for_this_product, 1)
	  product_quantity_scale.value = quantity
	  product_quantity_scale.width_request=(100)
	  # Hook up signal.
	  product_quantity_scale.signal_connect("value-changed") do |scale|
		@controller.set_product_quantity(product_name, scale.value)
	  end
	  
	  @scales_hash[product_name] = product_quantity_scale
	  
	  @stored_products_table.attach(product_name_label, table_row_iter, 1)
	  @stored_products_table.attach(product_quantity_scale, table_row_iter, 2)
	  
	  table_row_iter += 1
	end
	
	# WORKAROUND
	# If I don't force a show_all, the box won't show the new scales.
	@stored_products_table.show_all
  end
end