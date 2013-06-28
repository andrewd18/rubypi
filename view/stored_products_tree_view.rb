require_relative 'icon_column.rb'
require_relative 'text_column.rb'
require_relative 'stored_products_list_store.rb'
require_relative 'remove_products_from_building_dialog.rb'


class StoredProductsTreeView < Gtk::TreeView
  def initialize(building_model = nil)
	@building_model = building_model
	
	@stored_products_store = StoredProductsListStore.new(@building_model)
	
	super(@stored_products_store)
	
	# Create columns for the tree view.
	icon_column = IconColumn.new("Icon", 0)
	name_column = TextColumn.new("Name", 1)
	quantity_column = TextColumn.new("Quantity", 2)
	volume_column = TextColumn.new("Volume", 3)
	
	# Pack columns in tree view, left-to-right.
	self.append_column(icon_column)
	self.append_column(name_column)
	self.append_column(quantity_column)
	self.append_column(volume_column)
	
	# Tree View settings.
	self.reorderable = true
	
	return self
  end
  
  def remove_product_dialog
	# Get a tree iter to the selected row.
	row = self.selection
	tree_iter = row.selected
	
	selected_product_name = tree_iter.get_value(1)
	
	# Pop up the dialog.
	dialog = RemoveProductsFromBuildingDialog.new(@building_model, selected_product_name)
	dialog.run do |response|
	  # Dialog has been closed.
	  if ((dialog.quantity > 0) and
		  (response == Gtk::ResponseType::ACCEPT))
		
		@building_model.remove_qty_of_product(selected_product_name, dialog.quantity)
		
	  else
		puts "User canceled or quantity was equal to or less than zero."
	  end
	end
	
	# Remove the dialog now that we've acted on it.
	dialog.destroy
  end
  
  def building_model
	return @building_model
  end
  
  def building_model=(new_building_model)
	@building_model = new_building_model
	
	# Pass along to store.
	@stored_products_store.building_model = @building_model
  end
  
  def start_observing_model
	@stored_products_store.start_observing_model
  end
  
  def stop_observing_model
	@stored_products_store.stop_observing_model
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	# Clean this up manually.
	@stored_products_store.destroy
	
	super
  end
end