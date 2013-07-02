require 'gtk3'
require_relative 'select_building_combo_box.rb'
require_relative 'simple_table.rb'
require_relative 'overflow_percentage_progress_bar.rb'

class TransferProductsDialog < Gtk::Dialog
  
  def initialize(planet_model, source_building = nil, parent_window = nil)
	title = "Transfer Products"
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	
	@planet_model = planet_model
	
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo])
	
	
	# Create all the widgets we'll be using.
	source_label = Gtk::Label.new("Source:")
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
	@source_stored_products_tree_view = StoredProductsTreeView.new
	@source_stored_products_tree_view.signal_connect("row-activated") do
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
	
	# WORKAROUND
	# "self.child" is actually a vbox which we connect things to via pack_start.
	# For some reason self.vbox is deprecated. :/
	
	                          #rows, columns, homogenous?
	layout_table = SimpleTable.new(4, 2, false)
	
	# First row.
	# First cell
	source_selection_vbox = Gtk::Box.new(:vertical)
	source_selection_vbox.pack_start(source_label, :expand => false)
	source_selection_vbox.pack_start(@source_combo_box, :expand => false)
	
	# Wrap it in a frame and pack it in the layout table.
	source_label_and_combo_box_frame = Gtk::Frame.new
	source_label_and_combo_box_frame.add(source_selection_vbox)
	layout_table.attach(source_label_and_combo_box_frame, 1, 1, true, true, false, false)
	
	
	# Second cell.
	destination_selection_vbox = Gtk::Box.new(:vertical)
	destination_selection_vbox.pack_start(destination_label, :expand => false)
	destination_selection_vbox.pack_start(@destination_combo_box, :expand => false)
	
	# Wrap it in a frame and pack it in the layout table.
	destination_label_and_combo_box_frame = Gtk::Frame.new
	destination_label_and_combo_box_frame.add(destination_selection_vbox)
	layout_table.attach(destination_label_and_combo_box_frame, 1, 2, true, true, false, false)
	
	
	# Second row. Images of buildings.
	@source_building_image = BuildingImage.new(self.source)
	layout_table.attach(@source_building_image, 2, 1)
	
	@destination_building_image = BuildingImage.new(self.destination)
	layout_table.attach(@destination_building_image, 2, 2)
	
	
	# Third row. Percentage bars showing volume.
	@source_volume_used_bar = OverflowPercentageProgressBar.new
	layout_table.attach(@source_volume_used_bar, 3, 1)
	
	@destination_volume_used_bar = OverflowPercentageProgressBar.new
	layout_table.attach(@destination_volume_used_bar, 3, 2)
	
	# Fourth row.
	# First cell.
	source_stored_products_scrollbox.add(@source_stored_products_tree_view)
	source_stored_products_vbox = Gtk::Box.new(:vertical)
	source_stored_products_vbox.pack_start(source_stored_products_label, :expand => false)
	source_stored_products_vbox.pack_start(source_stored_products_scrollbox, :expand => true)
	
	source_stored_products_frame = Gtk::Frame.new
	source_stored_products_frame.add(source_stored_products_vbox)
	layout_table.attach(source_stored_products_frame, 4, 1)
	
	# Second cell
	destination_stored_products_scrollbox.add(@destination_stored_products_tree_view)
	destination_stored_products_vbox = Gtk::Box.new(:vertical)
	destination_stored_products_vbox.pack_start(destination_stored_products_label, :expand => false)
	destination_stored_products_vbox.pack_start(destination_stored_products_scrollbox, :expand => true)
	
	destination_stored_products_frame = Gtk::Frame.new
	destination_stored_products_frame.add(destination_stored_products_vbox)
	layout_table.attach(destination_stored_products_frame, 4, 2)
	
	self.child.pack_start(layout_table, :expand => true)
	
	
	# Finally, force the model to use the source building if it was passed in.
	# Can't do this earlier in the init because the widgets don't exist yet.
	if (source_building != nil)
	  self.source_changed
	end
	
	self.show_all
	
	return self
  end
  
  def source_changed
	# Set the source_stored_products_table to the building model pointed at by @source_combo_box
	@source_stored_products_tree_view.building_model = self.source
	
	@source_building_image.building_model = self.source
	# TODO - I shouldn't have to call update here. That should happen as part of the new model.
	@source_building_image.update
	
	@source_volume_used_bar.value = self.source.pct_volume_used
  end
  
  def destination_changed
	# Set the destination_stored_products_table to the building model pointed at by @destination_combo_box
	@destination_stored_products_tree_view.building_model = self.destination
	
	@destination_building_image.building_model = self.destination
	# TODO - I shouldn't have to call update here. That should happen as part of the new model.
	@destination_building_image.update
	
	@destination_volume_used_bar.value = self.destination.pct_volume_used
  end
  
  def source
	return @source_combo_box.selected_item
  end
  
  def destination
	return @destination_combo_box.selected_item
  end
  
  def create_how_many_dialog
	# TODO: Give a message to the user.
	# Error cleanly if there's no destination.
	return unless (self.destination != nil)
	
	# Figure out what the user clicked on.
	row = @source_stored_products_tree_view.selection
	tree_iter = row.selected
	
	selected_product_name = tree_iter.get_value(1)
	selected_quantity_stored = tree_iter.get_value(2)
	selected_product_volume = tree_iter.get_value(3)
	
	
	# Error if there is not enough volume in the destination.
	max_transferrable_quantity = ((self.destination.volume_available) / (selected_product_volume))
	max_transferrable_quantity = max_transferrable_quantity.to_int
	
	if (max_transferrable_quantity == 0)
	  # Quit quietly. TODO: Error without popping up ANOTHER dialog box.
	  return
	end
	
	
	
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
	
	# Limit the slider.
	# If you've got more product than the destination can hold, your top limit is the destination volume.
	# If you've got less product than the destination can hold, your top limit is the product amount.
	if (selected_quantity_stored > max_transferrable_quantity)
														# min,        #max,   # adjust_by
	  product_quantity_slider = Gtk::Scale.new(:horizontal, 0, max_transferrable_quantity, 1)
	else
	  														# min,        #max,   # adjust_by
	  product_quantity_slider = Gtk::Scale.new(:horizontal, 0, selected_quantity_stored, 1)
	end
	
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
	
	# Force an update.
	self.source_changed
	self.destination_changed
  end
end