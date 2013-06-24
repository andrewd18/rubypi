class TextColumn < Gtk::TreeViewColumn
  def initialize(name, model_column)
	text_renderer = Gtk::CellRendererText.new
	
	super(name, text_renderer, :text => model_column)
	
	self.reorderable = true
	
	self.alignment = 0.5 # Center
	
	# Sort by the model column you passed in.
	self.sort_column_id = model_column
	
	return self
  end
end