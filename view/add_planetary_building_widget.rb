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

class AddPlanetaryBuildingWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	@planet_model = planet_model
	
	add_label = Gtk::Label.new("Add Buildings")
	self.pack_start(add_label, :expand => false)
	
	# One planetary building of each type.
	buildings = Array.new
	
	buildings << CommandCenter.new
	buildings << StorageFacility.new
	buildings << Launchpad.new
	buildings << Extractor.new
	buildings << BasicIndustrialFacility.new
	buildings << AdvancedIndustrialFacility.new
	buildings << HighTechIndustrialFacility.new
	
	@building_list_store = Gtk::ListStore.new(Integer,			# UID
	                                          Gdk::Pixbuf,		# Icon
	                                          Class,			# Class Name
	                                          String)			# Name
	
	buildings.each_with_index do |building, index|
	  # Create a new row, attached to the top of the tree.
	  new_row = @building_list_store.append
	  new_row.set_value(0, index)
	  new_row.set_value(1, BuildingImage.new(building, [32, 32]).pixbuf)
	  new_row.set_value(2, building.class)
	  new_row.set_value(3, building.name)
	end
	
	# Create the tree view.
	@tree_view = Gtk::TreeView.new(@building_list_store)
	
	# Create cell renderers.
	text_renderer = Gtk::CellRendererText.new
	image_renderer = Gtk::CellRendererPixbuf.new
	
	# Create columns for the tree view.
	icon_column = Gtk::TreeViewColumn.new("Icon", image_renderer, :pixbuf => 1)
	# Don't bother showing the class.
	name_column = Gtk::TreeViewColumn.new("Name", text_renderer, :text => 3)
	
	# Pack columns in tree view, left-to-right.
	@tree_view.append_column(icon_column)
	@tree_view.append_column(name_column)
	
	@tree_view.headers_visible = false
	
	# When a row is double-clicked, add the building.
	@tree_view.signal_connect("row-activated") do |tree_view, path, column|
	  add_building(tree_view, path, column)
	end
	
	# When the widget loses focus, deselect the row.
	@tree_view.signal_connect("focus-out-event") do |tree_view, event|
	  tree_view.selection.unselect_all
	end
	
	self.pack_start(@tree_view)
	
	self.show_all
	
	return self
  end
  
  def add_building(tree_view, path, column)
	iter = @building_list_store.get_iter(path)
	building_class = iter.get_value(2)
	
	begin
	  @planet_model.add_building_from_class(building_class)
	rescue ArgumentError => error
	  # TODO - Tell the user what happened nicely.
	  # For now, spit it out to the command line.
	  puts error
	end
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end