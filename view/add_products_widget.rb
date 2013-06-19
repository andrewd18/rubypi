require_relative 'add_products_tree_view.rb'

class AddProductsWidget < Gtk::ScrolledWindow
  def initialize(building_model)
	super(nil)
	
	@building_model = building_model
	
	self.set_policy(Gtk::PolicyType::AUTOMATIC, Gtk::PolicyType::AUTOMATIC)
	
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