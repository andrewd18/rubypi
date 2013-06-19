require_relative 'add_products_tree_store.rb'

require_relative 'icon_column.rb'
require_relative 'text_column.rb'

require_relative 'add_products_to_building_dialog.rb'


class AddProductsTreeView < Gtk::TreeView
  def initialize(building_model)
	# Get a list of all products, one p-level at a time.
	# Create a tree store based on 'em.
	# Display them.
	# On-double-click, create an AddProductsToBuildingDialog.
	
	@building_model = building_model
	
	@tree_model = AddProductsTreeStore.new
	super(@tree_model)
	
	# Create columns for the tree view.
	icon_column = IconColumn.new("Icon", 0)
	name_column = TextColumn.new("Name", 1)
	
	# Pack columns in tree view, left-to-right.
	self.append_column(icon_column)
	self.append_column(name_column)
	
	
	# Signals
	# On double-click, run the add_product_dialog method.
	self.signal_connect("row-activated") do |tree_view, path, column|
	  self.add_product_dialog
	end
	
	return self
  end
  
  def add_product_dialog
	# Get a tree iter to the selected row.
	row = self.selection
	tree_iter = row.selected
	
	selected_product_name = tree_iter.get_value(1)
	
	# TODO
	if (@building_model.volume_available == 0)
	  # Display an error.
	  puts "No volume available."
	else
	  dialog = AddProductsToBuildingDialog.new(@building_model, selected_product_name)
	  dialog.run do |response|
		case response
		when Gtk::ResponseType::ACCEPT
		  dialog.quantity
			
		  @building_model.store_product(selected_product_name, dialog.quantity)
		  
		  # TODO
		  # 1. Show exception if necessary.
		else
		  puts "canceled"
		end
	  end
	  
	  dialog.destroy
	end
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	@tree_model.destroy
	
	super
  end
end