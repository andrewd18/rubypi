class IconColumn < Gtk::TreeViewColumn
  def initialize(name, model_column)
	image_renderer = Gtk::CellRendererPixbuf.new
	
	super(name, image_renderer, :pixbuf => model_column)
	
	# Can't sort based on an icon.
	self.sort_indicator = false
	self.sort_column_id = -1
	
	return self
  end
end