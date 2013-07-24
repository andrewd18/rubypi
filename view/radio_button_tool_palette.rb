require 'gtk3'

class RadioButtonToolPalette < Gtk::Toolbar
  def initialize
	super()
	
	return self
  end
  
  def group
	return self.children.first
  end
  
  def append_stock_tool_button(stock_id)
	# WORKAROUND:
	# Gtk::RadioToolButton sets itself up like a linked list.
	# It doesn't want to know its parent array, it wants to know an item in the list.
	# Therefore I pass self.children.last when appending.
	
	new_tool = Gtk::RadioToolButton.new(self.children.last, stock_id)
	  
	self.insert(new_tool, (self.children.size))
	
	return new_tool
  end
  
  def prepend_stock_tool_button(stock_id)
	# WORKAROUND:
	# Gtk::RadioToolButton sets itself up like a linked list.
	# It doesn't want to know its parent array, it wants to know an item in the list.
	# Therefore I pass self.children.first when prepending.
	
	new_tool = Gtk::RadioToolButton.new(self.children.first, stock_id)
	
	self.insert(new_tool, 0)
	
	return new_tool
  end
  
  def append_custom_tool_button(tool_button)
	# WORKAROUND:
	# Gtk::RadioToolButton sets its group up like a linked list.
	# If it's the first button, don't set a group.
	# If it's not the first button, pass it an item in the list.
	if (self.group != nil)
	  tool_button.group=(self.group)
	end
	
	self.insert(tool_button, (self.children.size))
	
	return
  end
  
  def prepend_custom_tool_button(tool_button)
	# WORKAROUND:
	# Gtk::RadioToolButton sets its group up like a linked list.
	# If it's the first button, don't set a group.
	# If it's not the first button, pass it an item in the list.
	if (self.group != nil)
	  tool_button.group=(self.group)
	end
	
	self.insert(tool_button, 0)
	
	return
  end
  
  def append_gtk_action_proxy_button(gtk_action)
	raise unless (gtk_action.is_a?(Gtk::Action))
	
	new_tool = Gtk::RadioToolButton.new
	new_tool.set_related_action(gtk_action)
	
	if (self.group != nil)
	  new_tool.group=(self.group)
	end
	
	self.insert(new_tool, (self.children.size))
	
	return new_tool
  end
  
  def prepend_gtk_action_proxy_button(gtk_action)
	raise unless (gtk_action.is_a?(Gtk::Action))
	
	new_tool = Gtk::RadioToolButton.new
	new_tool.set_related_action(gtk_action)
	
	if (self.group != nil)
	  new_tool.group=(self.group)
	end
	
	self.insert(new_tool, 0)
	
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