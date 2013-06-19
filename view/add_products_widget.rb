require_relative 'add_products_tree_view.rb'

class AddProductsWidget < Gtk::ScrolledWindow
  def initialize
	super
	
	self.set_policy(Gtk::PolicyType::AUTOMATIC, Gtk::PolicyType::AUTOMATIC)
	
	@add_products_tree_view = AddProductsTreeView.new
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