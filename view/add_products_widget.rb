require_relative 'add_products_tree_view.rb'

class AddProductsWidget < Gtk::ScrolledWindow
  def initialize(building_model)
	super(nil)
	
	@building_model = building_model
	
	# Never have a horizontal scrollbar.
	# Have a vertical scrollbar if necessary.
	self.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	
	@add_products_tree_view = AddProductsTreeView.new(@building_model)
	self.add(@add_products_tree_view)
	
	return self
  end

  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end