require 'gtk3'

require_relative '../model/planetary_building.rb'
require_relative '../model/advanced_industrial_facility.rb'
require_relative '../model/basic_industrial_facility.rb'
require_relative '../model/command_center.rb'
require_relative '../model/extractor.rb'
require_relative '../model/high_tech_industrial_facility.rb'
require_relative '../model/launchpad.rb'
require_relative '../model/storage_facility.rb'

require_relative './building_image.rb'

class ListOfBuildingsWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	buildings_label = Gtk::Label.new("Buildings")
	
	@planet_model = planet_model
	@planet_model.add_observer(self)
	
	#                                              UID,     Icon,       Name, CPU Used, PG Used. CPU Prov, PG Prov, ISK Cost
	@list_store_of_buildings = Gtk::ListStore.new(Integer, Gdk::Pixbuf, String, Integer, Integer, Integer, Integer, Integer)
	
	# Update planet list from model.
	update
	
	# Finally, create a tree view.
	@tree_view = Gtk::TreeView.new(@list_store_of_buildings)
	
	text_renderer = Gtk::CellRendererText.new
	image_renderer = Gtk::CellRendererPixbuf.new
	
	icon_column = Gtk::TreeViewColumn.new("Icon", image_renderer, :pixbuf => 1)
	name_column = Gtk::TreeViewColumn.new("Name", text_renderer, :text => 2)
	cpu_usage_column = Gtk::TreeViewColumn.new("CPU Usage", text_renderer, :text => 3)
	pg_usage_column = Gtk::TreeViewColumn.new("PG Usage", text_renderer, :text => 4)
	cpu_provided_column = Gtk::TreeViewColumn.new("CPU Provided", text_renderer, :text => 5)
	pg_provided_column = Gtk::TreeViewColumn.new("PG Provided", text_renderer, :text => 6)
	isk_cost_column = Gtk::TreeViewColumn.new("ISK", text_renderer, :text => 7)
	
	@tree_view.append_column(icon_column)
	@tree_view.append_column(name_column)
	@tree_view.append_column(cpu_usage_column)
	@tree_view.append_column(pg_usage_column)
	@tree_view.append_column(cpu_provided_column)
	@tree_view.append_column(pg_provided_column)
	@tree_view.append_column(isk_cost_column)
	
	# On a double-click, remove the building.
	@tree_view.signal_connect("row-activated") do |tree_view, path, column|
	  remove_building(tree_view, path, column)
	end
	
	# Pack the label and the tree view into the box.
	self.pack_start(buildings_label, :expand => false, :fill => false)
	self.pack_start(@tree_view, :expand => true, :fill => true)
	self.show_all
	
	return self
  end
  
  def remove_building(tree_view, path, column)
	iter = @list_store_of_buildings.get_iter(path)
	
	# Get the iter for the building we want dead.
	building_iter_value = iter.get_value(0)
	
	@planet_model.remove_building(@planet_model.buildings[building_iter_value])
  end
  
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @list_store_of_buildings.clear
	  
	  # Update planet building list from model.
	  @planet_model.buildings.each_with_index do |building, index|
		new_row = @list_store_of_buildings.append
		new_row.set_value(0, index)
		new_row.set_value(1, BuildingImage.new(building, [32, 32]).pixbuf)
		new_row.set_value(2, building.name)
		new_row.set_value(3, building.cpu_usage)
		new_row.set_value(4, building.powergrid_usage)
		new_row.set_value(5, building.cpu_provided)
		new_row.set_value(6, building.powergrid_provided)
		new_row.set_value(7, building.isk_cost)
	  end
	end
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	@planet_model.delete_observer(self)
	
	super
  end
end