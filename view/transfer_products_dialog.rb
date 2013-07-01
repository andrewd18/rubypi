require 'gtk3'
require_relative 'select_building_combo_box.rb'
require_relative 'simple_table.rb'

class TransferProductsDialog < Gtk::Dialog
  
  def initialize(planet_model, source_building = nil, parent_window = nil)
	title = "Transfer Products"
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	second_button_response_id_combo = [Gtk::Stock::CANCEL, Gtk::ResponseType::REJECT]
	
	@planet_model = planet_model
	
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo, second_button_response_id_combo])
	
	
	# Create all the widgets we'll be using.
	source_label = Gtk::Label.new("Source:")
	products_to_transfer_label = Gtk::Label.new("Products to Transfer:")
	destination_label = Gtk::Label.new("Destination:")
	
	@source_combo_box = SelectBuildingComboBox.new(@planet_model.aggregate_launchpads_ccs_storages)
	@source_combo_box.selected_item = source_building
	@source_combo_box.signal_connect("changed") do |combo_box|
	  self.source_changed
	end
	
	@destination_combo_box = SelectBuildingComboBox.new(@planet_model.aggregate_launchpads_ccs_storages)
	@destination_combo_box.signal_connect("changed") do |combo_box|
	  self.destination_changed
	end
	
	
	source_stored_products_label = Gtk::Label.new("Stored Products")
	@source_stored_products_list_view = StoredProductsTreeView.new
	@source_stored_products_list_view.signal_connect("row-activated") do
	  self.create_how_many_dialog
	end
	
	source_stored_products_scrollbox = Gtk::ScrolledWindow.new
	# Never have a horizontal scrollbar. Have a vertical scrollbar if necessary.
	source_stored_products_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	
	
	
	destination_stored_products_label = Gtk::Label.new("Stored Products")
	@destination_stored_products_tree_view = StoredProductsTreeView.new
	
	destination_stored_products_scrollbox = Gtk::ScrolledWindow.new
	# Never have a horizontal scrollbar. Have a vertical scrollbar if necessary.
	destination_stored_products_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	
	
	# Layout (needed for #update)
	                            # rows, columns, homogenous?
	layout_table = SimpleTable.new(3, 2, false)
	
	# Pack all the things that haven't been dynamically created.
	
	# First row
	layout_table.attach(source_label, 1, 1)
	layout_table.attach(destination_label, 1, 2)
	
	
	# Second row
	layout_table.attach(@source_combo_box, 2, 1)
	# blank space
	layout_table.attach(@destination_combo_box, 2, 2)
	
	
	# Third row.
	# Left column.
	source_stored_products_scrollbox.add(@source_stored_products_list_view)
	
	source_stored_products_vbox = Gtk::Box.new(:vertical)
	source_stored_products_vbox.pack_start(source_stored_products_label, :expand => false)
	source_stored_products_vbox.pack_start(source_stored_products_scrollbox, :expand => true)
	
	source_stored_products_frame = Gtk::Frame.new
	source_stored_products_frame.add(source_stored_products_vbox)
	layout_table.attach(source_stored_products_frame, 3, 1)
	
	# Right column.
	destination_stored_products_scrollbox.add(@destination_stored_products_tree_view)
	
	destination_stored_products_vbox = Gtk::Box.new(:vertical)
	destination_stored_products_vbox.pack_start(destination_stored_products_label, :expand => false)
	destination_stored_products_vbox.pack_start(destination_stored_products_scrollbox, :expand => true)
	
	destination_stored_products_frame = Gtk::Frame.new
	destination_stored_products_frame.add(destination_stored_products_vbox)
	layout_table.attach(destination_stored_products_frame, 3, 2)
	
	self.child.add(layout_table)
	
	self.show_all
	
	return self
  end
  
  def source_changed
	# Set the source_stored_products_table to the building model pointed at by @source_combo_box
	@source_stored_products_list_view.building_model = self.source
  end
  
  def destination_changed
	# Set the destination_stored_products_table to the building model pointed at by @destination_combo_box
	@destination_stored_products_tree_view.building_model = self.destination
  end
  
  def source
	return @source_combo_box.selected_item
  end
  
  def destination
	return @destination_combo_box.selected_item
  end
  
  def create_how_many_dialog
	# Error cleanly if there's no destination.
	return unless (self.destination != nil)
	
	# Figure out what the user clicked on.
	row = @source_stored_products_list_view.selection
	tree_iter = row.selected
	selected_product_name = tree_iter.get_value(1)
	selected_quantity_stored = tree_iter.get_value(2)
	selected_product_volume = tree_iter.get_value(3)
	
	# Pop up a dialog asking how many of the selected product.
	
	# Dialog options.
	title = "How Many?"
	parent_window = self
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	second_button_response_id_combo = [Gtk::Stock::CANCEL, Gtk::ResponseType::REJECT]
	
	# Create the dialog.
	how_many_dialog = Gtk::Dialog.new(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo, second_button_response_id_combo])
	
	# Create a label with the name of the product.
	product_name_label = Gtk::Label.new("#{selected_product_name}")
	
	# Create a slider bar. It should not allow the user to add more products than the destination has volume.
	max_quantity_given_available_volume = ((self.destination.volume_available) / (selected_product_volume))
	
	# Limit the slider.
	if (selected_quantity_stored > max_quantity_given_available_volume)
	  int_max_quantity = max_quantity_given_available_volume.to_int
	else
	  int_max_quantity = selected_quantity_stored
	end
	
	                                                   # min,        #max,                          # adjust_by
	product_quantity_slider = Gtk::Scale.new(:horizontal, 0, int_max_quantity, 1)
	
	# Create a horizontal box and pack the widgets.
	how_many_hbox = Gtk::Box.new(:horizontal)
	how_many_hbox.pack_start(product_name_label, :expand => false)
	how_many_hbox.pack_start(product_quantity_slider, :expand => true)
	
	how_many_dialog.child.add(how_many_hbox)
	how_many_dialog.show_all
	
	how_many_dialog.run do |response|
	  if (response == Gtk::ResponseType::ACCEPT)
		self.perform_transfer(selected_product_name, product_quantity_slider)
	  else
		puts "Transfer canceled."
	  end
	end
	
	how_many_dialog.destroy
  end
  
  def perform_transfer(product_name, product_quantity_slider)
	self.source.remove_qty_of_product(product_name, product_quantity_slider.value)
	
	self.destination.store_product(product_name, product_quantity_slider.value)
  end
end