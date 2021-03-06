require 'gtk3'
require_relative '../common/select_building_combo_box.rb'
require_relative '../common/building_image.rb'
require_relative 'set_extraction_time_slider.rb'

require_relative '../gtk_helpers/simple_combo_box.rb'
require_relative '../gtk_helpers/simple_table.rb'

# This widget provides all the options necessary to edit an Extractor.
class ExtractorView < Gtk::Box
  
  def initialize(controller)
	super(:vertical)
	
	# Hook up model data.
	@controller = controller
	
	# Create the top row.
	# Top row should contain a label stating what view we're looking at, followed by an UP button.
	top_row = Gtk::Box.new(:horizontal)
	
	building_view_label = Gtk::Label.new("Extractor View")
	
	# Add our up button.
	@up_button = UpToPlanetViewButton.new(@controller)
	
	top_row.pack_start(building_view_label, :expand => true)
	top_row.pack_start(@up_button, :expand => false)
	self.pack_start(top_row, :expand => false)
	
	
	# Create the bottom row.
	# Bottom row should contain the specialized widget that lets you edit the building's model.
	bottom_row = Gtk::Box.new(:horizontal)
	
	# Create widgets.
	
	# Extractor Details Frame
	
	# Left column.
	extractor_label = Gtk::Label.new("Extractor")
	@building_image = BuildingImage.new
	
	extract_label = Gtk::Label.new("Extract:")
	@product_combo_box = SimpleComboBox.new
	
	extraction_time_label = Gtk::Label.new("Extraction Time in Hours:")
	@extraction_time_scale = SetExtractionTimeSlider.new
	
	extracted_quantity_label = Gtk::Label.new("Extracted Quantity Per Hour:")
	@extracted_quantity_slider = Gtk::Scale.new(:horizontal, 0, Extractor::MAX_EXTRACTION_QUANTITY_PER_HOUR, 1)
	
	
	
	# Right column
	output_building_label = Gtk::Label.new("Output Building")
	
	@output_building_combo_box = SelectBuildingComboBox.new
	@output_building_image = BuildingImage.new
	@output_building_stored_products_widget = StoredProductsWidget.new(@controller)
	
	
	# Pack columns top to bottom
	extractor_column = Gtk::Box.new(:vertical)
	extractor_column.pack_start(extractor_label, :expand => false)
	extractor_column.pack_start(@building_image, :expand => false)
	
											# rows, columns
	extractor_options_table = SimpleTable.new(3, 2)
	
	# attach(widget, row, column)
	extractor_options_table.attach(extract_label, 1, 1)
	extractor_options_table.attach(@product_combo_box, 1, 2)
	extractor_options_table.attach(extraction_time_label, 2, 1)
	extractor_options_table.attach(@extraction_time_scale, 2, 2)
	extractor_options_table.attach(extracted_quantity_label, 3, 1)
	extractor_options_table.attach(@extracted_quantity_slider, 3, 2)
	
	extractor_column.pack_start(extractor_options_table, :expand => false)
	
	extractor_column_frame = Gtk::Frame.new
	extractor_column_frame.add(extractor_column)
	
	
	output_building_vbox = Gtk::Box.new(:vertical)
	output_building_vbox.pack_start(output_building_label, :expand => false)
	output_building_vbox.pack_start(@output_building_combo_box, :expand => false)
	output_building_vbox.pack_start(@output_building_image, :expand => false)
	output_building_vbox.pack_start(@output_building_stored_products_widget, :expand => true)
	
	output_building_frame = Gtk::Frame.new
	output_building_frame.add(output_building_vbox)
	
	# Pack columns into the row, left to right.
	bottom_row.pack_start(extractor_column_frame, :expand => true)
	bottom_row.pack_start(output_building_frame, :expand => false)
	
	
	# Set up signals.
	@on_product_change_signal = @product_combo_box.signal_connect("changed") do |combo_box|
	  @controller.set_extracted_product_name(combo_box.selected_item)
	end
	
	@on_extraction_time_change_signal = @extraction_time_scale.signal_connect("value-changed") do |scale|
	  @controller.set_extraction_time_scale(scale.value)
	end
	
	@on_extracted_quantity_change_signal = @extracted_quantity_slider.signal_connect("value-changed") do |scale|
	  @controller.set_extracted_quantity(scale.value)
	end
	
	@on_output_building_change_signal = @output_building_combo_box.signal_connect("changed") do |combo_box|
	  @controller.set_output_building(combo_box.selected_item)
	end
	
	
	self.pack_start(bottom_row, :expand => true)
	
	self.show_all
	
	return self
  end
  
  def building_model=(new_building_model)
	@building_model = new_building_model
	
	
	# Extractor itself.
	@building_image.building_model = @building_model
	
	@product_combo_box.signal_handler_block(@on_product_change_signal) do
	  @product_combo_box.items = (@building_model.planet.pzero_product_list)
	  @product_combo_box.selected_item = (@building_model.product_name)
	end
	
	@extraction_time_scale.signal_handler_block(@on_extraction_time_change_signal) do
	  if (@building_model.extraction_time_in_hours == nil)
		@extraction_time_scale.value = 1.0
	  else
		@extraction_time_scale.value = @building_model.extraction_time_in_hours
	  end
	end
	
	@extracted_quantity_slider.signal_handler_block(@on_extracted_quantity_change_signal) do
	  @extracted_quantity_slider.value = @building_model.quantity_extracted_per_hour
	end
	
	# Output building.
	unless (@building_model.production_cycle_output_building == nil)
	  @output_building_image.building_model = @building_model.production_cycle_output_building
	end
	
	@output_building_stored_products_widget.building_model = @building_model.production_cycle_output_building
	
	@output_building_combo_box.signal_handler_block(@on_output_building_change_signal) do
	  @output_building_combo_box.items = (@building_model.planet.aggregate_launchpads_ccs_storages)
	  @output_building_combo_box.selected_item = @building_model.production_cycle_output_building
	end
	
  end
end