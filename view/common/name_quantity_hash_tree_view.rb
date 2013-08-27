require_relative '../gtk_helpers/icon_column.rb'
require_relative '../gtk_helpers/text_column.rb'

require_relative 'name_quantity_hash_list_store.rb'

class NameQuantityHashTreeView < Gtk::TreeView
  def initialize(name_quantity_hash)
	@list_model = NameQuantityHashListStore.new()
	super(@list_model)
	
	self.name_quantity_hash = name_quantity_hash
	
	# Create columns for the tree view.
	icon_column = IconColumn.new("Icon", 0)
	name_column = TextColumn.new("Name", 1)
	quantity_column = TextColumn.new("Quantity", 2)
	
	# Pack columns in tree view, left-to-right.
	self.append_column(icon_column)
	self.append_column(name_column)
	self.append_column(quantity_column)
	
	return self
  end
  
  def name_quantity_hash=(new_hash)
	# Pass to store.
	@list_model.name_quantity_hash = new_hash
  end
  
  def destroy
	@list_model.destroy
	
	super
  end
end