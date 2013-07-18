require 'gtk3'

class RadioButtonToolPalette < Gtk::Toolbar
  def initialize
	super()
	
	return self
  end
  
  def append_new_tool(stock_id = nil)
	# WORKAROUND:
	# Gtk::RadioToolButton sets itself up like a linked list.
	# It doesn't want to know its parent array, it wants to know its precursor in the list.
	# Therefore I pass self.children.last when appending.
	
 	if (stock_id == nil)
	  new_tool = Gtk::RadioToolButton.new(self.children.last)
	  
 	  self.insert(new_tool, (self.children.size))
 	else
	  new_tool = Gtk::RadioToolButton.new(self.children.last, stock_id)
	  
 	  self.insert(new_tool, (self.children.size))
 	end
	
	return new_tool
  end
  
  def prepend_new_tool(stock_id = nil)
	# WORKAROUND:
	# Gtk::RadioToolButton sets itself up like a linked list.
	# It doesn't want to know its parent array, it wants to know its precursor in the list.
	# Therefore I pass self.children.first when prepending.
	
	if (stock_id == nil)
	  new_tool = Gtk::RadioToolButton.new(self.children.first)
	  
 	  self.insert(new_tool, 0)
 	else
	  new_tool = Gtk::RadioToolButton.new(self.children.first, stock_id)
	  
 	  self.insert(new_tool, 0)
 	end
	
	return new_tool
  end
  
  def active_tool
	self.children.each do |tool|
	  if (tool.active?)
		return tool
	  end
	end
  end
end