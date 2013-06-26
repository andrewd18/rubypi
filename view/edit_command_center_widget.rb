
require 'gtk3'

require_relative 'expedited_transfer_button.rb'
require_relative 'add_products_widget.rb'
require_relative 'stored_products_widget.rb'

# This widget provides all the options necessary to edit an Extractor.
class EditCommandCenterWidget < Gtk::Box
  
  attr_accessor :building_model
  
  def initialize(building_model)
	super(:horizontal)
	
	# Hook up model data.
	@building_model = building_model
	
	# Create widgets.
	# Left column.
	add_products_label = Gtk::Label.new("Add Products")
	@add_products_widget = AddProductsWidget.new(@building_model)
	
	
	# Center column.
	@stored_products_widget = StoredProductsWidget.new(@building_model)
	expedited_transfer_button = ExpeditedTransferButton.new(@building_model)
	
	
	# Right column.
	building_image = BuildingImage.new(@building_model)
	
	upgrade_level_label = Gtk::Label.new("Upgrade Level:")
	# Upgrade level spin button.						# min, max, step
	@upgrade_level_spin_button = Gtk::SpinButton.new(0, 5, 1)
	@upgrade_level_spin_button.numeric = true
	
	
	# Pack widgets into columns, left to right.
	# Left column.
	left_column = Gtk::Box.new(:vertical)
	left_column.pack_start(add_products_label, :expand => false)
	left_column.pack_start(@add_products_widget, :expand => true)
	left_column_frame = Gtk::Frame.new
	left_column_frame.add(left_column)
	
	self.pack_start(left_column_frame, :expand => false)
	
	
	# Center column.
	center_column = Gtk::Box.new(:vertical)
	center_column.pack_start(@stored_products_widget, :expand => true)
	button_row = Gtk::Box.new(:horizontal)
	button_row.pack_end(expedited_transfer_button, :expand => false)
	center_column.pack_start(button_row, :expand => false)
	center_column_frame = Gtk::Frame.new
	center_column_frame.add(center_column)
	
	self.pack_start(center_column_frame, :expand => true)
	
	
	# Right column.
	
	# Second row.
	right_column_upgrade_row = Gtk::Box.new(:horizontal)
	right_column_upgrade_row.pack_start(upgrade_level_label, :expand => false)
	right_column_upgrade_row.pack_start(@upgrade_level_spin_button, :expand => false)
	
	right_column = Gtk::Box.new(:vertical)
	right_column.pack_start(building_image, :expand => false)
	right_column.pack_start(right_column_upgrade_row, :expand => false)
	right_column_frame = Gtk::Frame.new
	right_column_frame.add(right_column)
	
	self.pack_start(right_column_frame, :expand => false)

	
	# Set the active iterater from the model data.
	# Since #update does this, call #update.
	update
	
	self.show_all
	
	return self
  end
  
  def start_observing_model
	@building_model.add_observer(self)
	
	@stored_products_widget.start_observing_model
  end
  
  def stop_observing_model
	@building_model.delete_observer(self)
	
	@stored_products_widget.stop_observing_model
  end
  
  # Called when the factory_model changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @upgrade_level_spin_button.value = @building_model.upgrade_level
	end
  end
  
  def commit_to_model
	# Stop observing so the values we want to set don't get overwritten on an #update.
	self.stop_observing_model
	
	upgrade_level_int = @upgrade_level_spin_button.value.to_i
	
	@building_model.set_level(upgrade_level_int)
	
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