require_relative '../gtk_helpers/icon_column.rb'
require_relative '../gtk_helpers/text_column.rb'

require_relative 'add_products_tree_store_with_filter.rb'
require_relative 'add_products_select_quantity_dialog.rb'


class AddProductsTreeView < Gtk::TreeView
  def initialize(controller)
	# Get a list of all products, one p-level at a time.
	# Create a tree store based on 'em.
	# Display them.
	# On-double-click, create an AddProductsToBuildingDialog.
	
	@controller = controller
	
	@tree_model = AddProductsTreeStoreWithFilter.new
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
	
	# Check for errors.
	# Make sure the selected product is a product and not a header or something else equally undefined.
	# TODO: I shouldn't have to do this. The model should bitch appropriately.
	if (Product.find_by_name(selected_product_name) == nil)
	  puts "User tried to add a product that does not have a definition in Product class."
	  return nil
	end
	
	# Make sure we have a building model before trying this.
	if (@building_model == nil)
	  puts "no building model"
	  return
	else
	  # OK! Pop up the dialog.
	  dialog = AddProductsSelectQuantityDialog.new(@building_model, selected_product_name, $ruby_pi_main_gtk_window)
	  dialog.run do |response|
		# Dialog has been closed.
		if ((dialog.quantity > 0) and
			(response == Gtk::ResponseType::ACCEPT))
		  
		  @controller.store_product(selected_product_name, dialog.quantity)
		  
		else
		  puts "User canceled or quantity was equal to or less than zero."
		end
	  end
	  
	  # Remove the dialog now that we've acted on it.
	  dialog.destroy
	end
  end
  
  def building_model=(new_building_model)
	@building_model = new_building_model
  end
end