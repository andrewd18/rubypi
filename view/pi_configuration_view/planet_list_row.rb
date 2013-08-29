require 'gtk3'

require_relative '../common/planet_image.rb'
require_relative '../common/building_count_table.rb'
require_relative 'planet_import_list.rb'

class PlanetListRow < Gtk::Box
  def initialize(controller, planet_model)
	super(:horizontal)
	
	@controller = controller
	@planet_model = planet_model
	
	planet_image_and_name_column = Gtk::Box.new(:vertical)
	@planet_image = PlanetImage.new(@planet_model)
	@planet_name_label = Gtk::Label.new("#{@planet_model.name}")
	planet_image_and_name_column.pack_start(@planet_image, :expand => false)
	planet_image_and_name_column.pack_start(@planet_name_label, :expand => false)
	
	@planet_buildings_box = BuildingCountTable.new(@planet_model)
	
	
	
	imports_label = Gtk::Label.new("Imports")
	@planet_import_list = PlanetImportList.new(@planet_model)
	planet_import_list_scrolled_window = Gtk::ScrolledWindow.new
	planet_import_list_scrolled_window.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	planet_import_list_scrolled_window.add(@planet_import_list)
	planet_imports_column = Gtk::Box.new(:vertical)
	planet_imports_column.pack_start(imports_label, :expand => false)
	planet_imports_column.pack_start(planet_import_list_scrolled_window, :expand => true)
	
	planet_export_list = Gtk::Label.new("Export List")
	
	edit_button_column = Gtk::Box.new(:vertical)
	edit_button = Gtk::Button.new(:label => "Edit")
	edit_button.image = Gtk::Image.new(:file => "view/images/16x16/edit-find-replace.png")
	edit_button.signal_connect("clicked") do |button|
	  unless (@planet_model == nil)
		@controller.edit_selected_planet(@planet_model)
	  end
	end
	edit_button_column.pack_start(edit_button, :expand => false)
	
	delete_button_column = Gtk::Box.new(:vertical)
	delete_button = Gtk::Button.new(:label => "Delete")
	delete_button.image = Gtk::Image.new(:file => "view/images/16x16/edit-find-replace.png")
	delete_button.signal_connect("clicked") do |button|
	  unless (@planet_model == nil)
		@controller.remove_planet(@planet_model)
	  end
	end
	delete_button_column.pack_start(delete_button, :expand => false)
	
	self.pack_start(planet_image_and_name_column, :padding => 5, :expand => false)
	self.pack_start(@planet_buildings_box, :padding => 5, :expand => false)
	self.pack_start(planet_imports_column, :padding => 5, :expand => true)
	self.pack_start(planet_export_list, :padding => 5, :expand => true)
	self.pack_start(edit_button_column, :padding => 5, :expand => false)
	self.pack_start(delete_button_column, :padding => 5, :expand => false)
	
	return self
  end
  
  def planet_model=(new_planet_model)
	@planet_model = new_planet_model
	
	# Update base widgets.
	@planet_name_label.text = "#{@planet_model.name}"
	
	# Push to complex children.
	@planet_image.planet_model = @planet_model
	@planet_buildings_box.planet_model = @planet_model
	@planet_import_list.planet_model = @planet_model
  end
end