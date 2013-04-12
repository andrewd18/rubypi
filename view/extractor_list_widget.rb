# This widget displays all of the Extractors for a given planet.
# This widget allows a user to remove a selected Extractor.
# This widget allows a user to edit a selected Extractor.

require_relative 'building_view_widget.rb'

class ExtractorListWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	# Hook up the back end data.
	@planet_model = planet_model
	@planet_model.add_observer(self)
	
	extractor_list_widget_label = Gtk::Label.new("Extractors")
	
	@extractor_tree_store = Gtk::TreeStore.new(Integer,			# UID
											   Gdk::Pixbuf,		# Icon
											   String,			# Name
	                                           Integer,			# PG Used
	                                           Integer,			# CPU Used
	                                           Integer)			# ISK Cost
	
	# Refresh extractor_list_store with model data.
	self.update
	
	# Create a tree view.
	@tree_view = Gtk::TreeView.new(@extractor_tree_store)
	
	# Create cell renderers.
	text_renderer = Gtk::CellRendererText.new
	image_renderer = Gtk::CellRendererPixbuf.new
	
	# Create columns for the tree view.
	icon_column = Gtk::TreeViewColumn.new("Icon", image_renderer, :pixbuf => 1)
	name_column = Gtk::TreeViewColumn.new("Name", text_renderer, :text => 2)
	pg_used_column = Gtk::TreeViewColumn.new("PG Used", text_renderer, :text => 3)
	cpu_used_column = Gtk::TreeViewColumn.new("CPU Used", text_renderer, :text => 4)
	isk_cost_column = Gtk::TreeViewColumn.new("ISK Cost", text_renderer, :text => 5)
	
	# Pack columns in tree view, left-to-right.
	@tree_view.append_column(icon_column)
	@tree_view.append_column(name_column)
	@tree_view.append_column(pg_used_column)
	@tree_view.append_column(cpu_used_column)
	@tree_view.append_column(isk_cost_column)
	
	# Create add/edit/remove buttons.
	row_of_buttons = Gtk::Box.new(:horizontal)
	
	edit_button = Gtk::Button.new(:stock_id => Gtk::Stock::EDIT)
	edit_button.signal_connect("clicked") do
	  row = @tree_view.selection
	  tree_iter = row.selected
	  
	  if (tree_iter != nil)
		self.edit_extractor(tree_iter)
	  end
	end
	
	delete_button = Gtk::Button.new(:stock_id => Gtk::Stock::DELETE)
	delete_button.signal_connect("clicked") do
	  row = @tree_view.selection
	  tree_iter = row.selected
	  
	  if (tree_iter != nil)
		self.delete_extractor(tree_iter)
	  end
	end
	
	# When the widget loses focus, deselect the row.
	@tree_view.signal_connect("focus-out-event") do |tree_view, event|
	  tree_view.selection.unselect_all
	end
	
	row_of_buttons.pack_start(edit_button)
	row_of_buttons.pack_start(delete_button)
	
	
	# Pack each of the children onto self and show them.
	self.pack_start(extractor_list_widget_label, :expand => false, :fill => false)
	self.pack_start(@tree_view, :expand => true, :fill => true)
	self.pack_start(row_of_buttons, :expand => false, :fill => false)
	self.show_all
	
	return self
  end
  
  # Called when planet_model changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @extractor_tree_store.clear
	  
	  # Update planet building list from model.
	  @planet_model.extractors.each_with_index do |extractor, index|
		extractor_row = @extractor_tree_store.append(nil)
		extractor_row.set_value(0, index)
		extractor_row.set_value(1, BuildingImage.new(extractor, [32, 32]).pixbuf)
		extractor_row.set_value(2, extractor.name)
		extractor_row.set_value(3, extractor.powergrid_usage)
		extractor_row.set_value(4, extractor.cpu_usage)
		extractor_row.set_value(5, extractor.isk_cost)
		
		extractor.extractor_heads.each do |head|
		  head_row = @extractor_tree_store.append(extractor_row)
		  head_row.set_value(0, index)
		  head_row.set_value(1, BuildingImage.new(head, [32, 32]).pixbuf)
		  head_row.set_value(2, head.name)
		  head_row.set_value(3, head.powergrid_usage)
		  head_row.set_value(4, head.cpu_usage)
		  head_row.set_value(5, head.isk_cost)
		end
	  end
	end
  end
  
  def edit_extractor(tree_iter)
	# Get the iter for the building we want to see.
	building_iter_value = tree_iter.get_value(0)
	
	# TODO - Edit specific extractor ID rather than relying on these iters matching.
	$ruby_pi_main_gtk_window.change_main_widget(BuildingViewWidget.new(@planet_model.extractors[building_iter_value]))
  end
  
def delete_extractor(tree_iter)
	# Get the iter for the building we want dead.
	building_iter_value = tree_iter.get_value(0)
	
	# TODO - Delete specific extractor ID rather than relying on these iters matching.
	@planet_model.remove_building(@planet_model.extractors[building_iter_value])
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	@planet_model.delete_observer(self)
	
	super
  end
end