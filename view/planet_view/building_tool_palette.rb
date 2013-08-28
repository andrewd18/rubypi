require_relative 'building_tool_radio_button.rb'

require_relative '../gtk_helpers/radio_button_tool_palette.rb'

class BuildingToolPalette < RadioButtonToolPalette
  def initialize(building_drawing_area)
	super()
	
	@building_drawing_area = building_drawing_area
	
	self.orientation=(:vertical)
	self.toolbar_style=(Gtk::Toolbar::Style::BOTH_HORIZ)
	self.show_arrow = false
	
	# Add all the various tools I'm going to want.
	# 
	# Import / Export... (click)
	# Expedited Transfer Between... (two-click)
	# ---------
	# Add building (click)
	# Move Building (click-drag)
	# Edit Building (click)
	# Delete building (click)
	# ---------
	# Add link between.... (two-click)
	# Edit Link Between... (two-click)
	# Delete link between... (two-click)
	#
	expedited_transfer_button = Gtk::RadioToolButton.new
	expedited_transfer_button.icon_widget = Gtk::Image.new(:file => "view/images/16x16/expedited_transfer_icon.png")
	expedited_transfer_button.label = "Expedited Transfer Between..."
	self.append_custom_tool_button(expedited_transfer_button)
	expedited_transfer_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("expedited_transfer")
	end
	
	import_export_button = Gtk::RadioToolButton.new
	import_export_button.icon_widget = Gtk::Image.new(:file => "view/images/16x16/poco_import_export_icon.png")
	import_export_button.label = "Import / Export Products"
	self.append_custom_tool_button(import_export_button)
	import_export_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("import_export")
	end
	
	
	self.append_separator
	
	
	building_class_names = Array.new
	building_class_names << CommandCenter
	building_class_names << StorageFacility
	building_class_names << Launchpad
	building_class_names << BasicIndustrialFacility
	building_class_names << AdvancedIndustrialFacility
	building_class_names << HighTechIndustrialFacility
	building_class_names << Extractor
	
	building_class_names.each do |class_name|
	  button = BuildingToolRadioButton.new(class_name)
	  self.append_custom_tool_button(button)
	  
	  button.signal_connect('clicked') do |button|
		@building_drawing_area.set_on_click_action("add_building")
		@building_drawing_area.set_add_building_type(button.building_class)
	  end
	end
	
	add_extractor_button = Gtk::RadioToolButton.new
	add_extractor_button.icon_widget = Gtk::Image.new(:file => "view/images/16x16/extractor_head_icon.png")
	add_extractor_button.label = "Add Extractor Head..."
	self.append_custom_tool_button(add_extractor_button)
	add_extractor_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("add_extractor_head")
	end
	
	move_tool_button = Gtk::RadioToolButton.new
	move_tool_button.icon_widget = Gtk::Image.new(:file => "view/images/16x16/move_building_icon.png")
	move_tool_button.label = "Move Building"
	self.append_custom_tool_button(move_tool_button)
	move_tool_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("move_building")
	end
	
	edit_building_button = Gtk::RadioToolButton.new
	edit_building_button.icon_widget = Gtk::Image.new(:file => "view/images/16x16/edit_building_icon.png")
	edit_building_button.label = "Edit Building"
	self.append_custom_tool_button(edit_building_button)
	edit_building_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("edit_building")
	end
	
	delete_building_button = Gtk::RadioToolButton.new
	delete_building_button.icon_widget = Gtk::Image.new(:file => "view/images/16x16/delete_building_icon.png")
	delete_building_button.label = "Delete Building"
	self.append_custom_tool_button(delete_building_button)
	delete_building_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("delete_building")
	end
	
	
	self.append_separator
	
	
	add_link_button = Gtk::RadioToolButton.new
	add_link_button.icon_widget = Gtk::Image.new(:file => "view/images/16x16/add_link_icon.png")
	add_link_button.label = "Add Link Between..."
	self.append_custom_tool_button(add_link_button)
	add_link_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("add_link")
	end
	
	edit_link_button = Gtk::RadioToolButton.new
	edit_link_button.icon_widget = Gtk::Image.new(:file => "view/images/16x16/edit_link_icon.png")
	edit_link_button.label = "Edit Link Between..."
	self.append_custom_tool_button(edit_link_button)
	edit_link_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("edit_link")
	end
	
	remove_link_button = Gtk::RadioToolButton.new
	remove_link_button.icon_widget = Gtk::Image.new(:file => "view/images/16x16/delete_link_icon.png")
	remove_link_button.label = "Delete Link Between..."
	self.append_custom_tool_button(remove_link_button)
	remove_link_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("delete_link")
	end
	
	# Set the default action.
	edit_building_button.active = true
	@building_drawing_area.set_on_click_action("edit_building")
	
	return self
  end
end