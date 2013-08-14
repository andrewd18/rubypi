
require 'gtk3'

# require_relative 'transfer_products_button.rb'
require_relative '../common/add_products_widget.rb'
require_relative '../common/stored_products_widget.rb'
require_relative '../common/building_image.rb'

class StorageFacilityView < Gtk::Box
  
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
	add_products_label = Gtk::Label.new("Add Products")
	@add_products_widget = AddProductsWidget.new(@controller)
	
	
	# Center column.
	@stored_products_widget = StoredProductsWidget.new(@controller)
	# transfer_products_button = TransferProductsButton.new(@building_model.planet, @building_model, $ruby_pi_main_gtk_window)
	
	
	# Right column.
	building_image = Gtk::Image.new(:file => "view/images/64x64/storage_facility_icon.png")
	
	
	
	# Pack widgets into columns, left to right.
	# Left column.
	left_column = Gtk::Box.new(:vertical)
	left_column.pack_start(add_products_label, :expand => false)
	left_column.pack_start(@add_products_widget, :expand => true)
	left_column_frame = Gtk::Frame.new
	left_column_frame.add(left_column)
	
	bottom_row.pack_start(left_column_frame, :expand => false)
	
	
	# Center column.
	center_column = Gtk::Box.new(:vertical)
	center_column.pack_start(@stored_products_widget, :expand => true)
	button_row = Gtk::Box.new(:horizontal)
	# button_row.pack_end(transfer_products_button, :expand => false)
	center_column.pack_start(button_row, :expand => false)
	center_column_frame = Gtk::Frame.new
	center_column_frame.add(center_column)
	
	bottom_row.pack_start(center_column_frame, :expand => true)
	
	
	# Right column.
	right_column = Gtk::Box.new(:vertical)
	right_column.pack_start(building_image, :expand => false)
	right_column_frame = Gtk::Frame.new
	right_column_frame.add(right_column)
	
	bottom_row.pack_start(right_column_frame, :expand => false)
	
	self.pack_start(bottom_row, :expand => true)
	
	self.show_all
	
	return self
  end
  
  def building_model=(new_building_model)
	@building_model = new_building_model
	
	# Pass new building_model to children.
	@add_products_widget.building_model = @building_model
	@stored_products_widget.building_model = @building_model
  end
end