require_relative 'icon_column.rb'
require_relative 'text_column.rb'

class StoredProductsTreeView < Gtk::TreeView
  def initialize(tree_or_list_model)
	@tree_or_list_model = tree_or_list_model
	
	super(@tree_or_list_model)
	
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
	
	# Signals
	# On double-click, remove the building.
	self.signal_connect("row-activated") do |tree_view, path, column|
	  row = self.selection
	  tree_iter = row.selected
	  
	  puts "row-activated signal"
	  #@tree_or_list_model.delete_building(tree_iter)
	end
	
	# Tree View settings.
	self.reorderable = true
	
	return self
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end