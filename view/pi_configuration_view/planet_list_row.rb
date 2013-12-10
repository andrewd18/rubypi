require 'gtk3'

require_relative '../common/planet_image.rb'
require_relative '../common/building_count_table.rb'
require_relative '../common/planet_import_list.rb'
require_relative '../common/planet_export_list.rb'
require_relative '../common/planet_adjusted_list.rb'

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
	
	edit_button = Gtk::Button.new(:label => "Edit")
	edit_button.image = Gtk::Image.new(:file => "view/images/16x16/view_in_planet_mode.png")
	edit_button.signal_connect("clicked") do |button|
	  unless (@planet_model == nil)
		@controller.edit_selected_planet(@planet_model)
	  end
	end
	
	delete_button = Gtk::Button.new(:label => "Delete")
	delete_button.image = Gtk::Image.new(:file => "view/images/16x16/delete_planet_icon.png")
	delete_button.signal_connect("clicked") do |button|
	  unless (@planet_model == nil)
		@controller.remove_planet(@planet_model)
	  end
	end
	
	planet_building_box_and_buttons_column = Gtk::Box.new(:vertical)
	planet_building_box_and_buttons_column.pack_start(@planet_buildings_box, :expand => false)
	
	planet_building_box_and_buttons_column.pack_end(delete_button, :expand => false)
	planet_building_box_and_buttons_column.pack_end(edit_button, :expand => false)
	
	
	imports_label = Gtk::Label.new("Products Used / Hour")
	@planet_import_list = PlanetImportList.new(@planet_model)
	planet_import_list_scrolled_window = Gtk::ScrolledWindow.new
	planet_import_list_scrolled_window.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	planet_import_list_scrolled_window.add(@planet_import_list)
	planet_import_cost_label = Gtk::Label.new("ISK Spent / Hour:")
	planet_import_cost_value = IskAmountLabel.new()
	import_isk_cost_row = Gtk::Box.new(:horizontal)
	import_isk_cost_row.pack_start(planet_import_cost_label)
	import_isk_cost_row.pack_start(planet_import_cost_value)
	
	planet_imports_column = Gtk::Box.new(:vertical)
	planet_imports_column.pack_start(imports_label, :expand => false)
	planet_imports_column.pack_start(planet_import_list_scrolled_window, :expand => true)
	planet_imports_column.pack_start(import_isk_cost_row, :expand => false)
	
	exports_label = Gtk::Label.new("Products Created / Hour")
	@planet_export_list = PlanetExportList.new(@planet_model)
	planet_export_scrolled_window = Gtk::ScrolledWindow.new
	planet_export_scrolled_window.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	planet_export_scrolled_window.add(@planet_export_list)
	planet_export_cost_label = Gtk::Label.new("ISK Created / Hour:")
	planet_export_cost_value = IskAmountLabel.new()
	export_isk_cost_row = Gtk::Box.new(:horizontal)
	export_isk_cost_row.pack_start(planet_export_cost_label)
	export_isk_cost_row.pack_start(planet_export_cost_value)
	
	planet_exports_column = Gtk::Box.new(:vertical)
	planet_exports_column.pack_start(exports_label, :expand => false)
	planet_exports_column.pack_start(planet_export_scrolled_window, :expand => true)
	planet_exports_column.pack_start(export_isk_cost_row, :expand => false)
	
	
	adjusted_label = Gtk::Label.new("Adjusted Products / Hour")
	@planet_adjusted_list = PlanetAdjustedList.new(@planet_model)
	planet_adjusted_scrolled_window = Gtk::ScrolledWindow.new
	planet_adjusted_scrolled_window.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	planet_adjusted_scrolled_window.add(@planet_adjusted_list)
	planet_adjusted_cost_label = Gtk::Label.new("Adj. ISK / Hour:")
	planet_adjusted_cost_value = IskAmountLabel.new()
	adjusted_isk_cost_row = Gtk::Box.new(:horizontal)
	adjusted_isk_cost_row.pack_start(planet_adjusted_cost_label)
	adjusted_isk_cost_row.pack_start(planet_adjusted_cost_value)
	
	
	planet_adjusted_column = Gtk::Box.new(:vertical)
	planet_adjusted_column.pack_start(adjusted_label, :expand => false)
	planet_adjusted_column.pack_start(planet_adjusted_scrolled_window, :expand => true)
	planet_adjusted_column.pack_start(adjusted_isk_cost_row, :expand => false)
	
	self.pack_start(planet_image_and_name_column, :padding => 5, :expand => false)
	self.pack_start(planet_building_box_and_buttons_column, :padding => 5, :expand => false)
	self.pack_start(planet_imports_column, :padding => 5, :expand => true)
	self.pack_start(planet_exports_column, :padding => 5, :expand => true)
	self.pack_start(planet_adjusted_column, :padding => 5, :expand => true)
	
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