require 'gtk3'

require_relative './text_column.rb'
require_relative './tree_store_from_hash.rb'

# Given a hash with text-parsable objects, displays the key and the value.

class TreeViewFromHash < Gtk::TreeView
  def initialize(hash, key_column_title = "Key", value_column_title = "Value")
	raise ArgumentError unless (hash.is_a?(Hash))
	
	@tree_model = TreeStoreFromHash.new(hash)
	super(@tree_model)
	
	# Create columns for the tree view.
	key_column = TextColumn.new(key_column_title, 0)
	value_column = TextColumn.new(value_column_title, 1)
	
	# Pack columns in tree view, left-to-right.
	self.append_column(key_column)
	self.append_column(value_column)
	
	return self
  end
  
  def hash=(new_hash)
	raise ArgumentError unless (new_hash.is_a?(Hash))
	
	@tree_model.new_hash=new_hash
  end
  
  def destroy
	# Manually clean up model.
	@tree_model.destroy
	
	super
  end
end