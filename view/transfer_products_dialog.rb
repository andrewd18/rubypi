require 'gtk3'
require_relative 'select_building_combo_box.rb'
require_relative 'simple_table.rb'

class TransferProductsDialog < Gtk::Dialog
  attr_reader :hash_to_transfer
  
  def initialize(planet_model)
	title = "Transfer Products"
	parent_window = nil
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	second_button_response_id_combo = [Gtk::Stock::CANCEL, Gtk::ResponseType::REJECT]
	
	@planet_model = planet_model
	@hash_to_transfer = Hash.new
	
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo, second_button_response_id_combo])
	
	
	# Create all the widgets we'll be using.
	source_label = Gtk::Label.new("Source:")
	products_to_transfer_label = Gtk::Label.new("Products to Transfer:")
	destination_label = Gtk::Label.new("Destination:")
	
	@source_combo_box = SelectBuildingComboBox.new(@planet_model.aggregate_launchpads_ccs_storages)
	@source_combo_box.signal_connect("changed") do |combo_box|
	  self.update
	end
	
	@destination_combo_box = SelectBuildingComboBox.new(@planet_model.aggregate_launchpads_ccs_storages)
	@destination_combo_box.signal_connect("changed") do |combo_box|
	  self.update
	end
	
	
	source_stored_products_label = Gtk::Label.new("Stored Products")
	@source_stored_products_list_view = StoredProductsTreeView.new
	@source_stored_products_list_view.signal_connect("row-activated") do
	  self.add_product_to_transfer_list
	end
	
	source_stored_products_scrollbox = Gtk::ScrolledWindow.new
	# Never have a horizontal scrollbar. Have a vertical scrollbar if necessary.
	source_stored_products_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	
	
	
	destination_stored_products_label = Gtk::Label.new("Stored Products")
	@destination_stored_products_tree_view = StoredProductsTreeView.new
	
	destination_stored_products_scrollbox = Gtk::ScrolledWindow.new
	# Never have a horizontal scrollbar. Have a vertical scrollbar if necessary.
	destination_stored_products_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	
	
	
	# Update the widgets from the model using #update.
	self.update
	
	
	# Layout (needed for #update)
	                            # rows, columns, homogenous?
	layout_table = SimpleTable.new(3, 3, false)
	
	# Pack all the things that haven't been dynamically created.
	
	# First row
	layout_table.attach(source_label, 1, 1)
	layout_table.attach(products_to_transfer_label, 1, 2)
	layout_table.attach(destination_label, 1, 3)
	
	
	# Second row
	layout_table.attach(@source_combo_box, 2, 1)
	# blank space
	layout_table.attach(@destination_combo_box, 2, 3)
	
	
	# Third row.
	# Left column.
	source_stored_products_scrollbox.add(@source_stored_products_list_view)
	
	source_stored_products_vbox = Gtk::Box.new(:vertical)
	source_stored_products_vbox.pack_start(source_stored_products_label, :expand => false)
	source_stored_products_vbox.pack_start(source_stored_products_scrollbox, :expand => true)
	
	source_stored_products_frame = Gtk::Frame.new
	source_stored_products_frame.add(source_stored_products_vbox)
	layout_table.attach(source_stored_products_frame, 3, 1)
	
	# Center column.
	# This gets filled in by add_product_to_transfer_list.
	@transfer_products_vbox = Gtk::Box.new(:vertical)
	layout_table.attach(@transfer_products_vbox, 3, 2)
	
	# Right column.
	destination_stored_products_scrollbox.add(@destination_stored_products_tree_view)
	
	destination_stored_products_vbox = Gtk::Box.new(:vertical)
	destination_stored_products_vbox.pack_start(destination_stored_products_label, :expand => false)
	destination_stored_products_vbox.pack_start(destination_stored_products_scrollbox, :expand => true)
	
	destination_stored_products_frame = Gtk::Frame.new
	destination_stored_products_frame.add(destination_stored_products_vbox)
	layout_table.attach(destination_stored_products_frame, 3, 3)
	
	self.child.add(layout_table)
	
	self.show_all
	
	return self
  end
  
  def update
	# Set the source_stored_products_table to the building model pointed at by @source_combo_box
	@source_stored_products_list_view.building_model = self.source
	
	# Set the destination_stored_products_table to the building model pointed at by @destination_combo_box
	@destination_stored_products_tree_view.building_model = self.destination
  end
  
  def add_product_to_transfer_list
	# Figure out what the user clicked on.
	row = @source_stored_products_list_view.selection
	tree_iter = row.selected
	selected_product_name = tree_iter.get_value(1)
	
	source_building = @source_combo_box.selected_item
	currently_stored_quantity = source_building.stored_products[selected_product_name]
	
	# Now we know what the user clicked on, as well as the quantity stored in the source building.
	# Add a new label and slider.
	product_name_label = Gtk::Label.new("#{selected_product_name}")
	product_quantity_slider = Gtk::Scale.new(:horizontal, 0, currently_stored_quantity, 1)
	product_quantity_slider.signal_connect("value-changed") do |slider|
	  @hash_to_transfer[selected_product_name]= slider.value
	end
	
	product_row = Gtk::Box.new(:horizontal)
	product_row.pack_start(product_name_label, :expand => false)
	product_row.pack_start(product_quantity_slider, :expand => true)
	
	@transfer_products_vbox.pack_start(product_row, :expand => false)
	
	@transfer_products_vbox.show_all
  end
  
  def source
	return @source_combo_box.selected_item
  end
  
  def destination
	return @destination_combo_box.selected_item
  end
end