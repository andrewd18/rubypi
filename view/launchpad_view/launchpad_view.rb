
require 'gtk3'

# require_relative 'transfer_products_button.rb'
require_relative '../common/add_products_widget.rb'

# This widget provides all the options necessary to edit a Launchpad.
class LaunchpadView < Gtk::Box
  
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
	# Left
	add_products_label = Gtk::Label.new("Add Products")
	@add_products_widget = AddProductsWidget.new(@controller)
	
	# Center
	@stored_products_widget = StoredProductsWidget.new(@controller)
	# transfer_products_button = TransferProductsButton.new(@building_model.planet, @building_model, $ruby_pi_main_gtk_window)
	
	# Right
	building_image = Gtk::Image.new(:file => "view/images/64x64/launchpad_icon.png")
	
	# Add pack widgets into columns, then pack columns left to right.
	# Left Column.
	add_products_column = Gtk::Box.new(:vertical)
	add_products_column.pack_start(add_products_label, :expand => false)
	add_products_column.pack_start(@add_products_widget, :expand => true)
	add_products_column_frame = Gtk::Frame.new
	add_products_column_frame.add(add_products_column)
	
	bottom_row.pack_start(add_products_column_frame, :expand => false)
	
	# Center column.
	stored_products_column = Gtk::Box.new(:vertical)
	stored_products_column.pack_start(@stored_products_widget, :expand => true)
	button_row = Gtk::Box.new(:horizontal)
	# button_row.pack_end(transfer_products_button, :expand => false)
	stored_products_column.pack_start(button_row, :expand => false)
	stored_products_column_frame = Gtk::Frame.new
	stored_products_column_frame.add(stored_products_column)
	
	bottom_row.pack_start(stored_products_column_frame, :expand => true)
	
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
	
	@add_products_widget.building_model = @building_model
	@stored_products_widget.building_model = @building_model
  end
end