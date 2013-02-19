require 'gtk3'

require_relative '../model/planetary_building.rb'
require_relative '../model/advanced_industrial_facility.rb'
require_relative '../model/basic_industrial_facility.rb'
require_relative '../model/command_center.rb'
require_relative '../model/extractor.rb'
require_relative '../model/high_tech_industrial_facility.rb'
require_relative '../model/launchpad.rb'
require_relative '../model/storage_facility.rb'

class PlanetaryBuildingWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	add_label = Gtk::Label.new("Buildings")
	
	@planet_model = planet_model
	@planet_model.add_observer(self)
	
	@list_store_of_buildings = Gtk::ListStore.new(Integer, String, Integer, Integer)
	
	# Update planet list from model.
	update
	
	# Finally, create a tree view.
	@tree_view = Gtk::TreeView.new(@list_store_of_buildings)
	
	# HACK: Ugly as hell. Ironically not as ugly as some of the other solutions.
	renderer = Gtk::CellRendererText.new
	name_column = Gtk::TreeViewColumn.new("Name", renderer, :text => 1)
	cpu_usage_column = Gtk::TreeViewColumn.new("CPU Usage", renderer, :text => 2)
	pg_usage_column = Gtk::TreeViewColumn.new("PG Usage", renderer, :text => 3)
	
	@tree_view.append_column(name_column)
	@tree_view.append_column(cpu_usage_column)
	@tree_view.append_column(pg_usage_column)
	
	
	@tree_view.signal_connect("row-activated") do |tree_view, path, column|
	  remove_building(tree_view, path, column)
	end
	
	self.pack_start(add_label)
	self.pack_start(@tree_view)
	self.show_all
	
	return self
  end
  
  def remove_building(tree_view, path, column)
	iter = @list_store_of_buildings.get_iter(path)
	
	# Get the iter for the building we want dead.
	building_iter_value = iter.get_value(0)
	
	@planet_model.remove_building(@planet_model.buildings[building_iter_value])
	
	# WRONG!
	# new_row = @list_store_of_buildings.append
	# new_row.set_value(0, iter.get_value(0))
	# new_row.set_value(1, iter.get_value(1))
	# new_row.set_value(2, iter.get_value(2))
  end
  
  def update
	@list_store_of_buildings.clear
	
	# Update planet building list from model.
	@planet_model.buildings.each_with_index do |building, index|
	  new_row = @list_store_of_buildings.append
	  new_row.set_value(0, index)
	  new_row.set_value(1, building.name)
	  new_row.set_value(2, building.cpu_usage)
	  new_row.set_value(3, building.powergrid_usage)
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