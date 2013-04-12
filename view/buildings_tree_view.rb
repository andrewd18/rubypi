class BuildingsTreeView < Gtk::TreeView
  def initialize(tree_or_list_model)
	@tree_or_list_model = tree_or_list_model
	
	super(@tree_or_list_model)
	
	# Create cell renderers.
	text_renderer = Gtk::CellRendererText.new
	image_renderer = Gtk::CellRendererPixbuf.new
	
	# Create columns for the tree view.
	icon_column = Gtk::TreeViewColumn.new("Icon", image_renderer, :pixbuf => 1)
	name_column = Gtk::TreeViewColumn.new("Name", text_renderer, :text => 2)
	schematic_name_column = Gtk::TreeViewColumn.new("Schematic", text_renderer, :text => 3)
	pg_used_column = Gtk::TreeViewColumn.new("PG Used", text_renderer, :text => 4)
	cpu_used_column = Gtk::TreeViewColumn.new("CPU Used", text_renderer, :text => 5)
	isk_cost_column = Gtk::TreeViewColumn.new("ISK Cost", text_renderer, :text => 6)
	
	# Pack columns in tree view, left-to-right.
	self.append_column(icon_column)
	self.append_column(name_column)
	self.append_column(schematic_name_column)
	self.append_column(pg_used_column)
	self.append_column(cpu_used_column)
	self.append_column(isk_cost_column)
	
	# Signals
	# On double-click, remove the building.
	self.signal_connect("row-activated") do |tree_view, path, column|
	  row = self.selection
	  tree_iter = row.selected
	  
	  @tree_or_list_model.delete_building(tree_iter)
	end
	
	return self
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end