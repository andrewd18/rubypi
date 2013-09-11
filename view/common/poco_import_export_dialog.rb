require 'gtk3'
require_relative '../gtk_helpers/overflow_percentage_progress_bar.rb'

require_relative '../../model/product.rb'

require_relative 'name_quantity_hash_tree_view.rb'
require_relative 'expedited_transfer_select_quantity_dialog.rb'

class POCOImportExportDialog < Gtk::Dialog
  
  REQUESTED_TREE_VIEW_HEIGHT = 100
  
  attr_reader :source_stored_products_hash
  attr_reader :destination_stored_products_hash
  
  def initialize(poco, launchpad, parent_window = nil)
	title = "Import / Export Products"
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	second_button_response_id_combo = [Gtk::Stock::CANCEL, Gtk::ResponseType::REJECT]
	
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo, second_button_response_id_combo])
	
	@poco = poco
	@transfer_isk_cost = 0
	
	# Load values from model objects.
	@source_stored_products_hash = Hash.new
	@source_stored_products_hash.replace(poco.stored_products)
	
	@destination_stored_products_hash = Hash.new
	@destination_stored_products_hash.replace(launchpad.stored_products)
	
	@source_total_volume = poco.storage_volume
	@source_used_volume = poco.volume_used
	
	@destination_total_volume = launchpad.storage_volume
	@destination_used_volume = launchpad.volume_used
	
	# Create columns.
	
	# Left column.
	# Source building.
	
	# Create the widgets.
	source_label = Gtk::Label.new("Source:")
	@source_building_image = BuildingImage.new(poco)
	
	@source_volume_used_bar = OverflowPercentageProgressBar.new
	@source_volume_used_bar.value = source_pct_used_volume
	
	source_stored_products_label = Gtk::Label.new("Stored Products")
	
	source_stored_products_scrollbox = Gtk::ScrolledWindow.new
	source_stored_products_scrollbox.height_request = REQUESTED_TREE_VIEW_HEIGHT
	# Never have a horizontal scrollbar. Have a vertical scrollbar if necessary.
	source_stored_products_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	
	@source_stored_products_tree_view = NameQuantityHashTreeView.new(@source_stored_products_hash)
	@source_stored_products_tree_view.signal_connect("row-activated") do |tree_view, tree_path, tree_column|
	  # What product did the user click on?
	  row = tree_view.selection
	  tree_iter = row.selected
	  selected_product_name = tree_iter.get_value(1)
	  selected_product_quantity = tree_iter.get_value(2)
	  selected_product_volume = tree_iter.get_value(3)
	  
	  # Figure out the maximum number of the product that will fit, given potential volume available.
	  max_transferrable_quantity = [(destination_available_volume / selected_product_volume), (selected_product_quantity)].min
	  max_transferrable_quantity = max_transferrable_quantity.to_int
	  
	  if (max_transferrable_quantity <= 0)
		# TODO: Show this to the user.
		# For now, dump it out to the CLI.
		puts "Cannot transfer. This would overflow the destination."
	  else
		self.ask_for_quantity_and_transfer_from(@source_stored_products_hash, @destination_stored_products_hash, selected_product_name, max_transferrable_quantity)
	  end
	end
	
	# Pack into column.
	source_building_column = Gtk::Box.new(:vertical)
	source_building_column.pack_start(source_label, :expand => false)
	source_building_column.pack_start(@source_building_image, :expand => false)
	source_building_column.pack_start(@source_volume_used_bar, :expand => false)
	source_building_column.pack_start(source_stored_products_label, :expand => false)
	
	source_stored_products_scrollbox.add(@source_stored_products_tree_view)
	source_building_column.pack_start(source_stored_products_scrollbox, :expand => true)
	
	source_building_frame = Gtk::Frame.new
	source_building_frame.add(source_building_column)
	
	# Right column.
	# Destination building.
	
	# Create the widgets.
	destination_label = Gtk::Label.new("Destination:")
	@destination_building_image = BuildingImage.new(launchpad)
	
	@destination_volume_used_bar = OverflowPercentageProgressBar.new
	@destination_volume_used_bar.value = destination_pct_used_volume
	
	destination_stored_products_label = Gtk::Label.new("Stored Products")
	
	destination_stored_products_scrollbox = Gtk::ScrolledWindow.new
	destination_stored_products_scrollbox.height_request = REQUESTED_TREE_VIEW_HEIGHT
	# Never have a horizontal scrollbar. Have a vertical scrollbar if necessary.
	destination_stored_products_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	
	@destination_stored_products_tree_view = NameQuantityHashTreeView.new(@destination_stored_products_hash)
	@destination_stored_products_tree_view.signal_connect("row-activated") do |tree_view, tree_path, tree_column|
	  # What product did the user click on?
	  row = tree_view.selection
	  tree_iter = row.selected
	  selected_product_name = tree_iter.get_value(1)
	  selected_product_quantity = tree_iter.get_value(2)
	  selected_product_volume = tree_iter.get_value(3)
	  
	  # Figure out the maximum number of the product that will fit, given potential volume available.
	  # Select the smaller of the two.
	  max_transferrable_quantity = [(source_available_volume / selected_product_volume), (selected_product_quantity)].min
	  max_transferrable_quantity = max_transferrable_quantity.to_int
	  
	  if (max_transferrable_quantity <= 0)
		# TODO: Show this to the user.
		# For now, dump it out to the CLI.
		puts "Cannot transfer. This would overflow the source."
	  else
		self.ask_for_quantity_and_transfer_from(@destination_stored_products_hash, @source_stored_products_hash, selected_product_name, max_transferrable_quantity)
	  end
	end
	
	# Pack into column.
	destination_building_column = Gtk::Box.new(:vertical)
	destination_building_column.pack_start(destination_label, :expand => false)
	destination_building_column.pack_start(@destination_building_image, :expand => false)
	destination_building_column.pack_start(@destination_volume_used_bar, :expand => false)
	destination_building_column.pack_start(destination_stored_products_label, :expand => false)
	
	destination_stored_products_scrollbox.add(@destination_stored_products_tree_view)
	destination_building_column.pack_start(destination_stored_products_scrollbox, :expand => true)
	
	destination_building_frame = Gtk::Frame.new
	destination_building_frame.add(destination_building_column)
	
	
	
	# Pack columns left to right.
	top_row_hbox = Gtk::Box.new(:horizontal)
	top_row_hbox.pack_start(source_building_frame, :expand => false)
	top_row_hbox.pack_start(destination_building_frame, :expand => false)
	
	
	# Bottom row with isk cost.
	bottom_row_hbox = Gtk::Box.new(:horizontal)
	bottom_row_hbox.pack_start(Gtk::Label.new("Cost to Import / Export:"), :expand => false)
	@import_export_isk_cost_label = IskAmountLabel.new
	bottom_row_hbox.pack_start(@import_export_isk_cost_label, :expand => false)
	
	
	# WORKAROUND
	# "self.child" is actually a vbox which we connect things to via pack_start.
	# For some reason self.vbox is deprecated. :/
	self.child.pack_start(top_row_hbox, :expand => true)
	self.child.pack_start(bottom_row_hbox, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def ask_for_quantity_and_transfer_from(from_hash, to_hash, product_name, max_transferrable_quantity)
	# Pop up a dialog asking how many of the selected product.
	select_qty_dialog = ExpeditedTransferSelectQuantityDialog.new(product_name, max_transferrable_quantity, self)
	
	select_qty_dialog.run do |response|
	  if (response == Gtk::ResponseType::ACCEPT)
		# Figure out how much we're transferring.
		amount_to_transfer = select_qty_dialog.quantity
		
		# Subtract it from the from hash.
		from_hash[product_name] = (from_hash[product_name] - amount_to_transfer)
		
		# Add it to the to hash.
		if (to_hash[product_name] == nil)
		  to_hash[product_name] = amount_to_transfer
		else
		  to_hash[product_name] = (to_hash[product_name] + amount_to_transfer)
		end
		
		# HACK
		# Figure out if it's an import or an export and call appropriate poco method.
		# There are better ways to do this.
		if (from_hash == @destination_stored_products_hash)
		  # From launchpad to poco.
		  additional_isk_cost = @poco.export_cost_with_tax(product_name, amount_to_transfer)
		else
		  # From poco to lauchpad.
		  additional_isk_cost = @poco.import_cost_with_tax(product_name, amount_to_transfer)
		end
		
		# Add to the saved isk cost.
		@transfer_isk_cost += additional_isk_cost
	  end
	end
	
	select_qty_dialog.destroy
	
	self.update
  end
  
  def update
	@source_stored_products_tree_view.name_quantity_hash = @source_stored_products_hash
	@destination_stored_products_tree_view.name_quantity_hash = @destination_stored_products_hash
	
	# Update the available volume for the source.
	total_source_used_volume = 0
	
	@source_stored_products_hash.each_pair do |name, qty|
	  product_volume = Product.find_by_name(name).volume
	  total_source_used_volume += (product_volume * qty)
	end
	
	@source_used_volume = total_source_used_volume
	
	
	
	# Update the available volume for the destination.
	total_destination_used_volume = 0
	
	@destination_stored_products_hash.each_pair do |name, qty|
	  product_volume = Product.find_by_name(name).volume
	  total_destination_used_volume += (product_volume * qty)
	end
	
	@destination_used_volume = total_destination_used_volume
	
	# Finally, update the overflow percentage bars.
	@source_volume_used_bar.value = source_pct_used_volume
	@destination_volume_used_bar.value = destination_pct_used_volume
	
	
	# Update the cost label.
	@import_export_isk_cost_label.isk_value = (@transfer_isk_cost)
  end
  
  private
  
  def source_pct_used_volume
	return (@source_used_volume / (@source_total_volume / 100)).round(2)
  end
  
  def source_available_volume
	return (@source_total_volume - @source_used_volume)
  end
  
  def destination_pct_used_volume
	return (@destination_used_volume / (@destination_total_volume / 100)).round(2)
  end
  
  def destination_available_volume
	return (@destination_total_volume - @destination_used_volume)
  end
end