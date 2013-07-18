require 'gtk3'

class RadioButtonToolPalette < Gtk::Toolbar
  def initialize
	super()
	
	return self
  end
  
  def append_stock_tool_button(stock_id)
	# WORKAROUND:
	# Gtk::RadioToolButton sets itself up like a linked list.
	# It doesn't want to know its parent array, it wants to know its precursor in the list.
	# Therefore I pass self.children.last when appending.
	
	new_tool = Gtk::RadioToolButton.new(self.children.last, stock_id)
	  
	self.insert(new_tool, (self.children.size))
  end
  
  def prepend_stock_tool_button(stock_id)
	# WORKAROUND:
	# Gtk::RadioToolButton sets itself up like a linked list.
	# It doesn't want to know its parent array, it wants to know its precursor in the list.
	# Therefore I pass self.children.first when prepending.
	
	new_tool = Gtk::RadioToolButton.new(self.children.first, stock_id)
	  
	self.insert(new_tool, 0)
  end
  
  def append_custom_tool_button(image_filename, label_text)
	
	icon_widget = Gtk::Image.new(:file => image_filename)
	label_widget = Gtk::Label.new(label_text)
	
	# WORKAROUND:
	# Gtk::RadioToolButton sets itself up like a linked list.
	# It doesn't want to know its parent array, it wants to know its precursor in the list.
	# Therefore I pass self.children.last when appending.
	
	new_tool = Gtk::RadioToolButton.new(self.children.last)
	new_tool.icon_widget = icon_widget
	new_tool.label_widget = label_widget
	
	self.insert(new_tool, (self.children.size))
  end
  
  def prepend_custom_tool_button(icon_widget)
	
	icon_widget = Gtk::Image.new(:file => image_filename)
	label_widget = Gtk::Label.new(label_text)
	
	# WORKAROUND:
	# Gtk::RadioToolButton sets itself up like a linked list.
	# It doesn't want to know its parent array, it wants to know its precursor in the list.
	# Therefore I pass self.children.first when prepending.
	
	new_tool = Gtk::RadioToolButton.new(self.children.first)
	new_tool.icon_widget = icon_widget
	new_tool.label_widget = label_widget
	  
	self.insert(new_tool, 0)
  end
  
  def active_tool
	self.children.each do |tool|
	  if (tool.active?)
		return tool
	  end
	end
  end
end