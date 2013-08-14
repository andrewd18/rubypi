require 'gtk3'
require_relative '../common/select_building_combo_box.rb'
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
	
	building_view_label = Gtk::Label.new("Launchpad View")
	
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
	extract_label = Gtk::Label.new("Extract:")
	extraction_time_label = Gtk::Label.new("Extraction Time in Hours:")
	output_building_label = Gtk::Label.new("Output to:")
	
	
	# Center column.
	@product_combo_box = SimpleComboBox.new
	@on_product_change_signal = @product_combo_box.signal_connect("changed") do |combo_box|
	  @controller.set_extracted_product_name(combo_box.selected_item)
	end
	
	@output_building_combo_box = SelectBuildingComboBox.new
	@on_output_building_change_signal = @output_building_combo_box.signal_connect("changed") do |combo_box|
	  @controller.set_output_building(combo_box.selected_item)
	end
	
	@extraction_time_scale = SetExtractionTimeSlider.new
	@on_extraction_time_change_signal = @extraction_time_scale.signal_connect("value-changed") do |combo_box|
	  @controller.set_extraction_time_scale(combo_box.value)
	end
	
	# Right column.
	building_image = Gtk::Image.new(:file => "view/images/64x64/extractor_icon.png")
	
	
	                                    # rows, columns, homogenous?
	extractor_options_table = SimpleTable.new(3, 2, false)
	
	# Product row
	extractor_options_table.attach(extract_label, 2, 1)
	extractor_options_table.attach(@product_combo_box, 2, 2)
	
	# Time row
	extractor_options_table.attach(extraction_time_label, 3, 1)
	extractor_options_table.attach(@extraction_time_scale, 3, 2)
	
	# Output row
	extractor_options_table.attach(output_building_label, 4, 1)
	extractor_options_table.attach(@output_building_combo_box, 4, 2)
	
	# By wrapping the table in a vertical box, we ensure that the vbox expands
	# and the table does not.
	extractor_options_table_vbox = Gtk::Box.new(:vertical)
	extractor_options_table_vbox.pack_start(extractor_options_table, :expand => false)
	
	# Finally, add a decorator frame around it.
	extractor_options_table_frame = Gtk::Frame.new
	extractor_options_table_frame.add(extractor_options_table_vbox)
	
	
	
	
	# Right column.
	# By wrapping the image in a vertical box, we ensure that the vbox expands
	# and the image does not.
	building_image_column = Gtk::Box.new(:vertical)
	building_image_column.pack_start(building_image, :expand => false)
	
	# Finally, add a decorator frame around it.
	building_image_frame = Gtk::Frame.new
	building_image_frame.add(building_image_column)
	
	# Pack columns left to right.
	bottom_row.pack_start(extractor_options_table_frame, :expand => true)
	bottom_row.pack_start(building_image_frame, :expand => false)
	
	
	self.pack_start(bottom_row, :expand => true)
	
	self.show_all
	
	return self
  end
  
  def building_model=(new_building_model)
	@building_model = new_building_model
	
	# WORKAROUND
	# I wrap the view-update events in signal_handler_block(id) closures.
	# This temporarily nullifies the objects from sending GTK signal I previously hooked up.
	
	@product_combo_box.signal_handler_block(@on_product_change_signal) do
	  @product_combo_box.items = (@building_model.planet.pzero_product_list)
	  @product_combo_box.selected_item = (@building_model.product_name)
	end
	
	@output_building_combo_box.signal_handler_block(@on_output_building_change_signal) do
	  @output_building_combo_box.items = (@building_model.planet.aggregate_launchpads_ccs_storages)
	  @output_building_combo_box.selected_item = @building_model.production_cycle_output_building
	end
	
	@extraction_time_scale.signal_handler_block(@on_extraction_time_change_signal) do
	  if (@building_model.extraction_time_in_hours == nil)
		@extraction_time_scale.value = 1.0
	  else
		@extraction_time_scale.value = @building_model.extraction_time_in_hours
	  end
	end
	
  end
end