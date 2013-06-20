require 'gtk3'
require_relative 'simple_combo_box.rb'
require_relative 'set_extraction_time_slider.rb'
require_relative 'building_image.rb'

# This widget provides all the options necessary to edit an Extractor.
class EditExtractorWidget < Gtk::Box
  
  attr_accessor :building_model
  
  def initialize(building_model)
	super(:horizontal)
	
	# Hook up model data.
	@building_model = building_model
	
	# Create widgets.
	# Left column.
	number_of_heads_label = Gtk::Label.new("Number of Heads:")
	
	extract_label = Gtk::Label.new("Extract:")
	
	extraction_time_label = Gtk::Label.new("Extraction Time in Hours:")
	
	
	# Center column.
	# Create the spin button.						# min, max, step
	@number_of_heads_spin_button = Gtk::SpinButton.new(0, 10, 1)
	@number_of_heads_spin_button.numeric = true
	
	@product_combo_box = SimpleComboBox.new(@building_model.accepted_product_names)
	
	@extraction_time_scale = SetExtractionTimeSlider.new(@building_model)
	
	
	# Right column.
	building_image = BuildingImage.new(@building_model)
	
	
	
	# Set the active iterater from the model data.
	# Since #update does this, call #update.
	update
	
	
	# Pack widgets into rows.
	# Pack rows into columns.
	# Left column.
	number_of_heads_row = Gtk::Box.new(:horizontal)
	number_of_heads_row.pack_start(number_of_heads_label, :expand => false)
	number_of_heads_row.pack_start(@number_of_heads_spin_button)
	
	select_product_row = Gtk::Box.new(:horizontal)
	select_product_row.pack_start(extract_label, :expand => false)
	select_product_row.pack_start(@product_combo_box)
	
	extraction_time_row = Gtk::Box.new(:horizontal)
	extraction_time_row.pack_start(extraction_time_label, :expand => false)
	extraction_time_row.pack_start(@extraction_time_scale)
	
	
	left_column = Gtk::Box.new(:vertical)
	left_column.pack_start(number_of_heads_row, :expand => false)
	left_column.pack_start(select_product_row, :expand => false)
	left_column.pack_start(extraction_time_row, :expand => false)
	
	
	
	
	# Right column.
	building_image_column = Gtk::Box.new(:vertical)
	building_image_column.pack_start(building_image, :expand => false)
	
	# Pack columns left to right.
	self.pack_start(left_column, :expand => true)
	self.pack_start(building_image_column, :expand => false)
	
	
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
	  @number_of_heads_spin_button.value = @building_model.extractor_heads.count
	  
	  # Set the value in the combo box to the value from the model.
	  @product_combo_box.selected_item = @building_model.product_name
	  
	  # Set the slider to the value from the model.
	  if (@building_model.extraction_time_in_hours == nil)
		@extraction_time_scale.value = 1.0
	  else
		@extraction_time_scale.value = @building_model.extraction_time_in_hours
	  end
	end
  end
  
  def commit_to_model
	self.stop_observing_model
	
	@building_model.remove_all_heads
	
	num_heads_int = @number_of_heads_spin_button.value.to_i
	num_heads_int.times do
	  @building_model.add_extractor_head
	end
	
	# Set the model to the value of the combo box.
	@building_model.product_name = @product_combo_box.selected_item
	
	# Set the extraction time to the value of the slider.
	@building_model.extraction_time_in_hours = @extraction_time_scale.value
	
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