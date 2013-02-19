require 'gtk3'

require_relative '../model/planetary_building.rb'
require_relative '../model/advanced_industrial_facility.rb'
require_relative '../model/basic_industrial_facility.rb'
require_relative '../model/command_center.rb'
require_relative '../model/extractor.rb'
require_relative '../model/high_tech_industrial_facility.rb'
require_relative '../model/launchpad.rb'
require_relative '../model/storage_facility.rb'

class AddPlanetaryBuildingWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	@planet_model = planet_model
	
	add_label = Gtk::Label.new("Add Infrastructure")
	
	# One planetary building of each type.
	@buildings = Array.new
	
	@buildings << AdvancedIndustrialFacility.new
	@buildings << BasicIndustrialFacility.new
	@buildings << CommandCenter.new
	@buildings << Extractor.new
	@buildings << HighTechIndustrialFacility.new
	@buildings << Launchpad.new
	@buildings << StorageFacility.new
	
	#                                                 Icon,        Class,  Name,   CPU Usage, Powergrid Usage
	# list_store_of_building_types = Gtk::ListStore.new(Gdk::Pixbuf, String, String, Integer, Integer)
	@list_store_of_building_types = Gtk::ListStore.new(Class, String, Integer, Integer)
	
	@buildings.each do |building|
	  new_row = @list_store_of_building_types.append
	  # new_row.set_value(0, nil)
	  new_row.set_value(0, building.class)
	  new_row.set_value(1, building.name)
	  new_row.set_value(2, building.cpu_usage)
	  new_row.set_value(3, building.powergrid_usage)
	end
	
	
	# Finally, create a tree view.
	@tree_view = Gtk::TreeView.new(@list_store_of_building_types)
	
	# HACK: Ugly as hell. Ironically not as ugly as some of the other solutions.
	renderer = Gtk::CellRendererText.new
	name_column = Gtk::TreeViewColumn.new("Name", renderer, :text => 1)
	cpu_usage_column = Gtk::TreeViewColumn.new("CPU Usage", renderer, :text => 2)
	pg_usage_column = Gtk::TreeViewColumn.new("PG Usage", renderer, :text => 3)
	
	@tree_view.append_column(name_column)
	@tree_view.append_column(cpu_usage_column)
	@tree_view.append_column(pg_usage_column)
	
	
	@tree_view.signal_connect("row-activated") do |tree_view, path, column|
	  add_building(tree_view, path, column)
	end
	
	self.pack_start(add_label)
	self.pack_start(@tree_view)
	self.show_all
	
	return self
  end
  
  def add_building(tree_view, path, column)
	iter = @list_store_of_building_types.get_iter(path)
	
	@planet_model.add_building_from_class_name(iter.get_value(0))
	
	# new_row = @list_store_of_building_types.append
	# new_row.set_value(0, iter.get_value(0))
	# new_row.set_value(1, iter.get_value(1))
	# new_row.set_value(2, iter.get_value(2))
  end
end