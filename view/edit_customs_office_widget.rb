
require 'gtk3'

require_relative 'transfer_products_button.rb'
require_relative 'add_products_widget.rb'
require_relative 'building_image.rb'


# This widget provides all the options necessary to edit an Extractor.
class EditCustomsOfficeWidget < Gtk::Box
  
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
	transfer_products_button = TransferProductsButton.new(@building_model.planet, @building_model, $ruby_pi_main_gtk_window)
	
	
	# Right column.
	building_image = BuildingImage.new(@building_model)
	tax_rate_label = Gtk::Label.new("Tax Rate Percentage:")
	@tax_rate_scale = Gtk::Scale.new(:horizontal, CustomsOffice::MIN_TAX_RATE, CustomsOffice::MAX_TAX_RATE, 1)
	@tax_rate_scale.width_request = 100 # width request in pixels
	
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
	button_row.pack_end(transfer_products_button, :expand => false)
	center_column.pack_start(button_row, :expand => false)
	center_column_frame = Gtk::Frame.new
	center_column_frame.add(center_column)
	
	self.pack_start(center_column_frame, :expand => true)
	
	
	# Right column.
	right_column = Gtk::Box.new(:vertical)
	right_column.pack_start(building_image, :expand => false)
	tax_rate_row = Gtk::Box.new(:horizontal)
	tax_rate_row.pack_start(tax_rate_label, :expand => false)
	tax_rate_row.pack_start(@tax_rate_scale, :expand => true)
	right_column.pack_start(tax_rate_row, :expand => false)
	right_column_frame = Gtk::Frame.new
	right_column_frame.add(right_column)
	
	self.pack_start(right_column_frame, :expand => true)
	
	# Update from model.
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
	  @tax_rate_scale.value = @building_model.tax_rate
	end
  end
  
  def commit_to_model
	@building_model.tax_rate = @tax_rate_scale.value
  end
  
  def destroy
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end