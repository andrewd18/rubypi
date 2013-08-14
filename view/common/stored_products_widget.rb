require_relative 'stored_products_list_store.rb'
require_relative 'stored_products_tree_view.rb'

class StoredProductsWidget < Gtk::Box
  def initialize(controller)
	super(:vertical)
	
	@controller = controller
	
	# Create the widgets.
	stored_products_label = Gtk::Label.new("Stored Products")
	@stored_products_list_view = StoredProductsTreeView.new(@controller)
	
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
  
  def building_model=(new_building_model)
	@building_model = new_building_model
	
	@stored_products_list_view.building_model=(new_building_model)
  end
end