require 'gtk3'
require_relative 'select_building_combo_box.rb'
require_relative 'simple_table.rb'
require_relative 'overflow_percentage_progress_bar.rb'
require_relative 'transfer_products_select_quantity_dialog.rb'
require_relative '../model/launch_can.rb'

class LaunchProductsToSpaceDialog < Gtk::Dialog
  
  REQUESTED_TREE_VIEW_HEIGHT = 100
  
  def initialize(command_center, parent_window = nil)
	title = "Launch Products to Space"
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo])
	
	# Hook up the model.
	@command_center = command_center
	@launch_can = LaunchCan.new
	# The launch can dies when the dialog is closed. Just like my soul whenever anyone ever uses this awful CCP "feature".
	
	# Create all the widgets we'll be using.
	command_center_stored_products_label = Gtk::Label.new("Stored Products")
	@command_center_stored_products_tree_view = StoredProductsTreeView.new
	@command_center_stored_products_tree_view.building_model = @command_center
	@command_center_stored_products_tree_view.signal_connect("row-activated") do
	  self.create_how_many_dialog
	end
	
	command_center_stored_products_scrollbox = Gtk::ScrolledWindow.new
	command_center_stored_products_scrollbox.height_request = REQUESTED_TREE_VIEW_HEIGHT
	# Never have a horizontal scrollbar. Have a vertical scrollbar if necessary.
	command_center_stored_products_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	
	
	
	launch_can_stored_products_label = Gtk::Label.new("Stored Products")
	@launch_can_stored_products_tree_view = StoredProductsTreeView.new
	@launch_can_stored_products_tree_view.building_model = @launch_can
	
	launch_can_stored_products_scrollbox = Gtk::ScrolledWindow.new
	launch_can_stored_products_scrollbox.height_request = REQUESTED_TREE_VIEW_HEIGHT
	# Never have a horizontal scrollbar. Have a vertical scrollbar if necessary.
	launch_can_stored_products_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	
	                          #rows, columns, homogenous?
	layout_table = SimpleTable.new(3, 2, false)
	
	# First row. Images of buildings.
	command_center_building_image = BuildingImage.new(@command_center)
	layout_table.attach(command_center_building_image, 1, 1, false, false, false, false)
	
	@launch_can_image = Gtk::Image.new(:file => "view/images/eve_gate_64x64.png")
	layout_table.attach(@launch_can_image, 1, 2, false, false, false, false)
	
	
	# Second row. Percentage bars showing volume.
	@command_center_volume_used_bar = OverflowPercentageProgressBar.new
	layout_table.attach(@command_center_volume_used_bar, 2, 1, true, true, false, false)
	
	@launch_can_volume_used_bar = OverflowPercentageProgressBar.new
	layout_table.attach(@launch_can_volume_used_bar, 2, 2, true, true, false, false)
	
	# Third row.
	# First cell.
	command_center_stored_products_scrollbox.add(@command_center_stored_products_tree_view)
	command_center_stored_products_vbox = Gtk::Box.new(:vertical)
	command_center_stored_products_vbox.pack_start(command_center_stored_products_label, :expand => false)
	command_center_stored_products_vbox.pack_start(command_center_stored_products_scrollbox, :expand => true)
	
	command_center_stored_products_frame = Gtk::Frame.new
	command_center_stored_products_frame.add(command_center_stored_products_vbox)
	layout_table.attach(command_center_stored_products_frame, 3, 1)
	
	# Second cell
	launch_can_stored_products_scrollbox.add(@launch_can_stored_products_tree_view)
	launch_can_stored_products_vbox = Gtk::Box.new(:vertical)
	launch_can_stored_products_vbox.pack_start(launch_can_stored_products_label, :expand => false)
	launch_can_stored_products_vbox.pack_start(launch_can_stored_products_scrollbox, :expand => true)
	
	launch_can_stored_products_frame = Gtk::Frame.new
	launch_can_stored_products_frame.add(launch_can_stored_products_vbox)
	layout_table.attach(launch_can_stored_products_frame, 3, 2)
	
	
	# WORKAROUND
	# "self.child" is actually a vbox which we connect things to via pack_start.
	# For some reason self.vbox is deprecated. :/
	self.child.pack_start(layout_table, :expand => true)
	
	# Finally, force the views to update from the model.
	self.command_center_changed
	self.launch_can_changed
	
	self.show_all
	
	return self
  end
  
  def command_center_changed
	# The tree views will never need a whole new building model so we can let them update themselves.
	# However the percentage used bar does need to be updated.
	@command_center_volume_used_bar.value = @command_center.pct_volume_used
  end
  
  def launch_can_changed
	# The tree views will never need a whole new building model so we can let them update themselves.
	# However the percentage used bar does need to be updated.
	@launch_can_volume_used_bar.value = @launch_can.pct_volume_used
  end
  
  def create_how_many_dialog
	# Figure out what the user clicked on.
	row = @command_center_stored_products_tree_view.selection
	tree_iter = row.selected
	
	selected_product_name = tree_iter.get_value(1)
	selected_product_volume = tree_iter.get_value(3)
	
	# Figure out how many of these objects we can stuff into the launch can before it's full.
	max_transferrable_quantity = ((@launch_can.volume_available) / (selected_product_volume))
	max_transferrable_quantity = max_transferrable_quantity.to_int
	
	# Pop up a dialog asking how many of the selected product.
	transfer_products_select_quantity_dialog = TransferProductsSelectQuantityDialog.new(@command_center, @launch_can, selected_product_name, self)
	
	transfer_products_select_quantity_dialog.run do |response|
	  if (response == Gtk::ResponseType::ACCEPT)
		self.perform_transfer(selected_product_name, transfer_products_select_quantity_dialog.quantity)
	  end
	end
	
	transfer_products_select_quantity_dialog.destroy
  end
  
  def perform_transfer(product_name, quantity)
	@command_center.remove_qty_of_product(product_name, quantity)
	
	@launch_can.store_product(product_name, quantity)
	
	# Force an update.
	self.command_center_changed
	self.launch_can_changed
  end
end