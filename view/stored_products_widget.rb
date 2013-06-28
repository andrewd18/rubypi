require_relative 'stored_products_list_store.rb'
require_relative 'stored_products_tree_view.rb'

class StoredProductsWidget < Gtk::Box
  def initialize(building_model)
	super(:vertical)
	
	@building_model = building_model
	
	
	# Create the widgets.
	stored_products_label = Gtk::Label.new("Stored Products")
	@stored_products_list_view = StoredProductsTreeView.new(@building_model)
	expedited_transfer_button = ExpeditedTransferButton.new(@building_model)
	
	@stored_products_list_view.signal_connect("row-activated") do
	  @stored_products_list_view.remove_product_dialog
	end
	
	# Put the list view in a scrollbox.
	auto_scrollbox = Gtk::ScrolledWindow.new
	
	# Never have a horizontal scrollbar.
	# Have a vertical scrollbar if necessary.
	auto_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	
	auto_scrollbox.add(@stored_products_list_view)
	
	# Pack them top to bottom.
	self.pack_start(stored_products_label, :expand => false)
	self.pack_start(auto_scrollbox, :expand => true)
	
	self.show_all
	
	return self
  end
  
  def start_observing_model
	@stored_products_list_view.start_observing_model
  end
  
  def stop_observing_model
	@stored_products_list_view.stop_observing_model
  end

  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end