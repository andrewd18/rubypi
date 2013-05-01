require 'gtk3'

# A simple combo box that allows you to add and remove text-only items.
# Replaces (and simplifies) Gtk::ComboBoxText.

class SimpleComboBox < Gtk::ComboBox
  
  attr_accessor :cell_renderer
  
  def initialize(list_of_items = [])
	# Set up the combo box model.
	@items_list_store = Gtk::ListStore.new(String)
	super(:model => @items_list_store)
	
	
	# Set up the combo box view.
	@cell_renderer = Gtk::CellRendererText.new
	self.pack_start(@cell_renderer, false)
	# Tell the CellRendererText to pull its :text value from column 0.
	self.set_attributes(@cell_renderer, :text => 0)
	
	
	# Finally, fill the model with data.
	self.items=(list_of_items)
  end
  
  def add_item(text)
	raise ArgumentError, "#{text} must be a String." unless text.is_a?(String)
	
	new_row = @items_list_store.append
	new_row.set_value(0, text)
  end
  
  def remove_item(text)
	raise ArgumentError, "#{text} is not an item in this SimpleComboBox." unless self.contains_item?(text)
	
	# Get a tree iter
	@items_list_store.each do |model, path, iter|
	  if (iter.get_value(0) == text)
		# Remove the row associated with that tree iter.
		@items_list_store.remove(iter)
	  end
	end
  end
  
  def remove_all_items
	@items_list_store.clear
	
	return @items_list_store
  end
  
  def items
	array_of_item_values = Array.new
	
	@items_list_store.each do |model, path, iter|
	  array_of_item_values << iter.get_value(0)
	end
	
	return array_of_item_values
  end
  
  def items=(new_list_of_items)
	backup_of_items_list = self.items
	
	@items_list_store.clear
	
	begin
	  new_list_of_items.each do |item|
		self.add_item(item)
	  end
	rescue ArgumentError
	  # Something went wrong. Restore old @items.
	  self.items=(backup_of_items_list)
	  raise ArgumentError
	end
  end
  
  def selected_item
	# Ask the view what its active iter is. View will return nil if there is none or the path is invalid.
	selected_tree_iter = self.active_iter
	
	if (selected_tree_iter == nil)
	  return nil
	else
	  # Get its value and return it.
	  return selected_tree_iter.get_value(0)
	end
  end
  
  def selected_item=(text)
	if (text.nil?)
	  self.active_iter = nil
	else	
	  raise ArgumentError, "#{text} is not an item in this SimpleComboBox." unless self.contains_item?(text)
	  
	  # Hunt through the model to find the iter that corresponds to the passed in text.
	  @items_list_store.each do |model, path, iter|
		if (iter.get_value(0) == text)
		  
		  # If we find it, set the view to that iter value.
		  self.active_iter=iter
		end
	  end
	end
  end
  
  def contains_item?(text)
	@items_list_store.each do |model, path, iter|
	  if (iter.get_value(0) == text)
		return true
	  end
	end
	
	return false
  end
end