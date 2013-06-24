class TextColumnWithImageHeader < Gtk::TreeViewColumn
  def initialize(image_filename, model_column)
	text_renderer = Gtk::CellRendererText.new
	
	# BUG, TODO - Figure out why this doesn't change the alignment of the text.
	text_renderer.alignment = Pango::Layout::ALIGN_CENTER # See http://ruby-gnome2.sourceforge.jp/hiki.cgi?Pango%3A%3ALayout#Alignment
	
	# Force SUPER to be called with no values.
	super()
	
	# WORKAROUND:
	# Manually set all the TreeViewColumn values because you can't pass a widget to the constructor.
	self.pack_start(text_renderer, false)
	self.set_attributes(text_renderer, {:text => model_column})
	
	image_for_header = Gtk::Image.new(:file => image_filename)
	self.widget = image_for_header
	
	# WORKAROUND:
	# If you don't force the widget to show, it never will.
	self.widget.show
	
	self.reorderable = true
	
	# Set header alignment to center.
	self.alignment = 0.5 # Center
	
	# Sort by the model column you passed in.
	self.sort_column_id = model_column
	
	return self
  end
end