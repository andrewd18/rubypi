require 'gtk3'
require_relative 'select_building_combo_box.rb'
require_relative 'transfer_products_select_quantity_dialog.rb'
require_relative '../../model/product.rb'

require_relative '../gtk_helpers/simple_table.rb'
require_relative '../gtk_helpers/overflow_percentage_progress_bar.rb'

require_relative 'name_quantity_hash_tree_view.rb'

class TransferProductsDialog < Gtk::Dialog
  
  REQUESTED_TREE_VIEW_HEIGHT = 100
  
  attr_reader :source_building
  attr_reader :destination_building
  
  def initialize(controller, source_building, destination_building, parent_window = nil)
	title = "Transfer Products"
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	second_button_response_id_combo = [Gtk::Stock::CANCEL, Gtk::ResponseType::REJECT]
	
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo, second_button_response_id_combo])
	
	@controller = controller
	
	# Model
	# Make a copy of the source and destination buildings. 
	# These will be edited directly by the view so I can reuse model methods rather than replicate them.
	@source_building = source_building.dup
	@destination_building = destination_building.dup
	
	
	# Create columns.
	
	# Left column.
	# Source building.
	
	# Create the widgets.
	source_label = Gtk::Label.new("Source:")
	@source_building_image = BuildingImage.new(@source_building)
	source_stored_products_label = Gtk::Label.new("Stored Products")
	
	@source_volume_used_bar = OverflowPercentageProgressBar.new
	@source_volume_used_bar.value = @source_building.pct_volume_used
	
	source_stored_products_scrollbox = Gtk::ScrolledWindow.new
	source_stored_products_scrollbox.height_request = REQUESTED_TREE_VIEW_HEIGHT
	# Never have a horizontal scrollbar. Have a vertical scrollbar if necessary.
	source_stored_products_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	
	@source_stored_products_tree_view = StoredProductsTreeView.new(@controller)
	@source_stored_products_tree_view.building_model = @source_building
	@source_stored_products_tree_view.signal_connect("row-activated") do
	  self.ask_for_quantity_to_transfer_to_destination
	end
	
	# Pack into column.
	source_building_column = Gtk::Box.new(:vertical)
	source_building_column.pack_start(source_label, :expand => false)
	source_building_column.pack_start(@source_building_image, :expand => false)
	source_building_column.pack_start(source_stored_products_label, :expand => false)
	source_building_column.pack_start(@source_volume_used_bar, :expand => false)
	
	source_stored_products_scrollbox.add(@source_stored_products_tree_view)
	source_building_column.pack_start(source_stored_products_scrollbox, :expand => true)
	
	# Right column.
	# Destination building.
	
	# Create the widgets.
	destination_label = Gtk::Label.new("Destination:")
	@destination_building_image = BuildingImage.new(@destination_building)
	destination_stored_products_label = Gtk::Label.new("Stored Products")
	
	@destination_volume_used_bar = OverflowPercentageProgressBar.new
	@destination_volume_used_bar.value = @destination_building.pct_volume_used
	
	destination_stored_products_scrollbox = Gtk::ScrolledWindow.new
	destination_stored_products_scrollbox.height_request = REQUESTED_TREE_VIEW_HEIGHT
	# Never have a horizontal scrollbar. Have a vertical scrollbar if necessary.
	destination_stored_products_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	
	@destination_stored_products_tree_view = StoredProductsTreeView.new(@controller)
	@destination_stored_products_tree_view.building_model = @destination_building
	@destination_stored_products_tree_view.signal_connect("row-activated") do
	  self.ask_for_quantity_to_transfer_to_source
	end
	
	# Pack into column.
	destination_building_column = Gtk::Box.new(:vertical)
	destination_building_column.pack_start(destination_label, :expand => false)
	destination_building_column.pack_start(@destination_building_image, :expand => false)
	destination_building_column.pack_start(destination_stored_products_label, :expand => false)
	destination_building_column.pack_start(@destination_volume_used_bar, :expand => false)
	
	destination_stored_products_scrollbox.add(@destination_stored_products_tree_view)
	destination_building_column.pack_start(destination_stored_products_scrollbox, :expand => true)
	
	
	
	# Pack columns left to right.
	hbox = Gtk::Box.new(:horizontal)
	hbox.pack_start(source_building_column, :expand => false)
	hbox.pack_start(destination_building_column, :expand => false)
	
	# WORKAROUND
	# "self.child" is actually a vbox which we connect things to via pack_start.
	# For some reason self.vbox is deprecated. :/
	self.child.pack_start(hbox, :expand => true)
	
	self.show_all
	
	return self
  end
  
  def ask_for_quantity_to_transfer_to_destination
	# What product did the user click on?
	row = @source_stored_products_tree_view.selection
	tree_iter = row.selected
	selected_product_name = tree_iter.get_value(1)
	selected_product_volume = tree_iter.get_value(3)
	
	# Figure out the maximum number of the product that will fit, given potential volume available.
	max_transferrable_quantity = (@destination_building.volume_available / selected_product_volume)
	max_transferrable_quantity = max_transferrable_quantity.to_int
	
	if (max_transferrable_quantity <= 0)
	  puts "Cannot transfer. This would overflow the destination."
	else
	  # Pop up a dialog asking how many of the selected product.
	  transfer_products_select_quantity_dialog = TransferProductsSelectQuantityDialog.new(@source_building, @destination_building, selected_product_name, self)
	  
	  transfer_products_select_quantity_dialog.run do |response|
		if (response == Gtk::ResponseType::ACCEPT)
		  # Perform the transfer.
		  @destination_building.store_product(selected_product_name, transfer_products_select_quantity_dialog.quantity)
		  @source_building.remove_qty_of_product(selected_product_name, transfer_products_select_quantity_dialog.quantity)
		else
		  puts "Selecting quantity cancelled."
		end
	  end
	  
	  transfer_products_select_quantity_dialog.destroy
	end
	
	self.update
  end
  
  def ask_for_quantity_to_transfer_to_source
	# What product did the user click on?
	row = @destination_stored_products_tree_view.selection
	tree_iter = row.selected
	selected_product_name = tree_iter.get_value(1)
	selected_product_volume = tree_iter.get_value(3)
	
	# Figure out the maximum number of the product that will fit, given potential volume available.
	max_transferrable_quantity = (@source_building.volume_available / selected_product_volume)
	max_transferrable_quantity = max_transferrable_quantity.to_int
	
	if (max_transferrable_quantity <= 0)
	  puts "Cannot transfer. This would overflow the destination."
	else
	  # Pop up a dialog asking how many of the selected product.
	  transfer_products_select_quantity_dialog = TransferProductsSelectQuantityDialog.new(@destination_building, @source_building, selected_product_name, self)
	  
	  transfer_products_select_quantity_dialog.run do |response|
		if (response == Gtk::ResponseType::ACCEPT)
		  # Perform the transfer.
		  @source_building.store_product(selected_product_name, transfer_products_select_quantity_dialog.quantity)
		  @destination_building.remove_qty_of_product(selected_product_name, transfer_products_select_quantity_dialog.quantity)
		else
		  puts "Selecting quantity cancelled."
		end
	  end
	  
	  transfer_products_select_quantity_dialog.destroy
	end
	
	self.update
  end
  
  def update
	@source_stored_products_tree_view.building_model = @source_building
	@destination_stored_products_tree_view.building_model = @destination_building
  end
end