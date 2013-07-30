require_relative 'add_products_tree_view.rb'

class AddProductsWidget < Gtk::Box
  def initialize(building_model)
	super(:vertical)
	
	@building_model = building_model
	
	# Create a tree view.
	@add_products_tree_view = AddProductsTreeView.new(@building_model)
	
	# Create a filter entry widget.
	filter_model = @add_products_tree_view.model
	@filter_entry = Gtk::Entry.new
	@filter_entry.signal_connect('changed') do |filter_entry|
	  filter_model.query=(filter_entry.text)
	end
	
	# Create a scrollbox for the tree view.
	add_products_scrollbox = Gtk::ScrolledWindow.new
	# Never have a horizontal scrollbar.
	# Have a vertical scrollbar if necessary.
	add_products_scrollbox.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	add_products_scrollbox.add(@add_products_tree_view)
	
	# Add the filter first, then the tree view.
	self.add(@filter_entry)
	self.add(add_products_scrollbox, :expand => true, :fill => true)
	
	return self
  end

  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end