require_relative 'add_products_tree_store.rb'

require_relative 'icon_column.rb'
require_relative 'text_column.rb'


class AddProductsTreeView < Gtk::TreeView
  def initialize()
	# Get a list of all products, one p-level at a time.
	# Create a tree store based on 'em.
	# Display them.
	# On-double-click, create an AddProductsToStorageDialog.
	
	@tree_model = AddProductsTreeStore.new
	super(@tree_model)
	
	# Create columns for the tree view.
	icon_column = IconColumn.new("Icon", 0)
	name_column = TextColumn.new("Name", 1)
	
	# Pack columns in tree view, left-to-right.
	self.append_column(icon_column)
	self.append_column(name_column)
	
	return self
  end
  
   def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	@tree_model.destroy
	
	super
  end
end