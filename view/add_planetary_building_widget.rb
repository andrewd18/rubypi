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
	
	add_label = Gtk::Label.new("Add Infrastructure")
	self.pack_start(add_label, :expand => false)
	
	# One planetary building of each type.
	buildings = Array.new
	
	buildings << CommandCenter.new
	buildings << Extractor.new
	buildings << StorageFacility.new
	buildings << Launchpad.new
	buildings << BasicIndustrialFacility.new
	buildings << AdvancedIndustrialFacility.new
	buildings << HighTechIndustrialFacility.new
	
	
	buildings.each do |building|
	  new_row = Gtk::Box.new(:horizontal)
	  
	  image = BuildingImage.new(building, [32, 32])
	  
	  add_button = Gtk::Button.new(:stock_id => Gtk::Stock::ADD)
	  add_button.signal_connect("clicked") do
		@planet_model.add_building_from_class(building.class)
	  end
	  
	  new_row.pack_start(image, :expand => false)
	  new_row.pack_start(add_button, :expand => false)
	  self.pack_start(new_row, :expand => false)
	end
	
	self.show_all
	
	return self
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end