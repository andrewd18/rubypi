# This widget displays all of the Factories for a given planet.
# This widget allows a user to remove a selected Factory.
# This widget allows a user to edit a selected Factory.

require_relative 'building_view_widget.rb'

class FactoryListWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	# Hook up the back end data.
	@planet_model = planet_model
	@planet_model.add_observer(self)
	
	factory_list_widget_label = Gtk::Label.new("Factories")
	
	@factory_list_store = Gtk::ListStore.new(Integer,		# UID
											 Gdk::Pixbuf,	# Icon
											 String,		# Name
	                                         String,		# Schematic Name
	                                         Integer,		# PG Used
	                                         Integer,		# CPU Used
	                                         Integer)		# ISK Cost
	
	# Refresh factory_list_store with model data.
	self.update
	
	# Create a tree view.
	@tree_view = Gtk::TreeView.new(@factory_list_store)
	
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
	@tree_view.append_column(icon_column)
	@tree_view.append_column(name_column)
	@tree_view.append_column(schematic_name_column)
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
		self.edit_factory(tree_iter)
	  end
	end
	
	delete_button = Gtk::Button.new(:stock_id => Gtk::Stock::DELETE)
	delete_button.signal_connect("clicked") do
	  row = @tree_view.selection
	  tree_iter = row.selected
	  
	  if (tree_iter != nil)
		self.delete_factory(tree_iter)
	  end
	end
	
	row_of_buttons.pack_start(edit_button)
	row_of_buttons.pack_start(delete_button)
	
	
	# Pack each of the children onto self and show them.
	self.pack_start(factory_list_widget_label, :expand => false, :fill => false)
	self.pack_start(@tree_view, :expand => true, :fill => true)
	self.pack_start(row_of_buttons, :expand => false, :fill => false)
	self.show_all
	
	return self
  end
  
  # Called when planet_model changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @factory_list_store.clear
	  
	  # Update planet building list from model.
	  @planet_model.factories.each_with_index do |building, index|
		new_row = @factory_list_store.append
		new_row.set_value(0, index)
		new_row.set_value(1, BuildingImage.new(building, [32, 32]).pixbuf)
		new_row.set_value(2, building.name)
		
		if (building.schematic == nil)
		  new_row.set_value(3, "")
		else
		  new_row.set_value(3, building.schematic.name)
		end
		
		new_row.set_value(4, building.powergrid_usage)
		new_row.set_value(5, building.cpu_usage)
		new_row.set_value(6, building.isk_cost)
	  end
	end
  end
  
  def edit_factory(tree_iter)
	# Get the iter for the building we want to see.
	building_iter_value = tree_iter.get_value(0)
	
	# TODO - Edit specific factory ID rather than relying on these iters matching.
	$ruby_pi_main_gtk_window.change_main_widget(BuildingViewWidget.new(@planet_model.factories[building_iter_value]))
  end
  
def delete_factory(tree_iter)
	# Get the iter for the building we want dead.
	building_iter_value = tree_iter.get_value(0)
	
	# TODO - Delete specific factory ID rather than relying on these iters matching.
	@planet_model.remove_building(@planet_model.factories[building_iter_value])
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	@planet_model.delete_observer(self)
	
	super
  end
end