
require 'gtk3'

require_relative 'expedited_transfer_button.rb'
require_relative 'add_products_widget.rb'
require_relative 'building_image.rb'


# This widget provides all the options necessary to edit an Extractor.
class EditStorageFacilityWidget < Gtk::Box
  
  attr_accessor :building_model
  
  def initialize(building_model)
	super(:horizontal)
	
	# Hook up model data.
	@building_model = building_model
	
	# Create widgets.
	# Left column.
	add_products_label = Gtk::Label.new("Add Products:")
	@add_products_widget = AddProductsWidget.new(@building_model)
	
	
	# Center column.
	@stored_products_widget = StoredProductsWidget.new(@building_model)
	expedited_transfer_button = ExpeditedTransferButton.new(@building_model)
	
	
	# Right column.
	building_image = BuildingImage.new(@building_model)
	
	
	
	# Pack widgets into columns, left to right.
	# Left column.
	left_column = Gtk::Box.new(:vertical)
	left_column.pack_start(add_products_label, :expand => false)
	left_column.pack_start(@add_products_widget, :expand => true)
	
	self.pack_start(left_column, :expand => false)
	
	
	# Center column.
	center_column = Gtk::Box.new(:vertical)
	center_column.pack_start(@stored_products_widget, :expand => true)
	center_column.pack_start(expedited_transfer_button, :expand => false)
	
	self.pack_start(center_column, :expand => true)
	
	
	# Right column.
	right_column = Gtk::Box.new(:vertical)
	right_column.pack_start(building_image, :expand => false)
	
	self.pack_start(right_column, :expand => false)
	
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
	  # do nothing
	end
  end
  
  def commit_to_model
	# Do nothing.
  end
  
  def destroy
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end