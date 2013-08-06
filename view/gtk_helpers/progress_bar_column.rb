class ProgressBarColumn < Gtk::TreeViewColumn
  def initialize(name, text_value_column, fill_pct_value_column)
	progress_bar_renderer = Gtk::CellRendererProgress.new
	
	super(name, progress_bar_renderer, {:text => text_value_column, :value => fill_pct_value_column})
	
	self.reorderable = true
	
	self.alignment = 0.5 # Center
	
	# Sort by the model column you passed in.
	self.sort_column_id = text_value_column
	
	return self
  end
end