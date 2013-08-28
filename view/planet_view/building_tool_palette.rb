require_relative 'building_tool_radio_button.rb'

require_relative '../gtk_helpers/radio_button_tool_palette.rb'

class BuildingToolPalette < RadioButtonToolPalette
  def initialize(building_drawing_area)
	super()
	
	@building_drawing_area = building_drawing_area
	
	self.orientation=(:vertical)
	self.toolbar_style=(Gtk::Toolbar::Style::BOTH_HORIZ)
	self.show_arrow = false
	
	# Product Routing
	# 
	expedited_transfer_button = Gtk::RadioToolButton.new
	expedited_transfer_button.icon_widget = Gtk::Image.new(:file => "view/images/16x16/expedited_transfer_icon.png")
	expedited_transfer_button.label = "Expedited Transfer Between..."
	self.append_custom_tool_button(expedited_transfer_button)
	expedited_transfer_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("expedited_transfer")
	end
	
	self.append_separator
	
	# Building Creation and Deletion
	#
	add_command_center_button = BuildingToolRadioButton.new(CommandCenter)
	self.append_custom_tool_button(add_command_center_button)
	add_command_center_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("add_building")
	  @building_drawing_area.set_add_building_type(button.building_class)
	end
	
	add_storage_facility_button = BuildingToolRadioButton.new(StorageFacility)
	self.append_custom_tool_button(add_storage_facility_button)
	add_storage_facility_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("add_building")
	  @building_drawing_area.set_add_building_type(button.building_class)
	end
	
	add_launchpad_button = BuildingToolRadioButton.new(Launchpad)
	self.append_custom_tool_button(add_launchpad_button)
	add_launchpad_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("add_building")
	  @building_drawing_area.set_add_building_type(button.building_class)
	end
	
	add_basic_industrial_facility_button = BuildingToolRadioButton.new(BasicIndustrialFacility)
	self.append_custom_tool_button(add_basic_industrial_facility_button)
	add_basic_industrial_facility_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("add_building")
	  @building_drawing_area.set_add_building_type(button.building_class)
	end
	
	add_advanced_industrial_facility_button = BuildingToolRadioButton.new(AdvancedIndustrialFacility)
	self.append_custom_tool_button(add_advanced_industrial_facility_button)
	add_advanced_industrial_facility_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("add_building")
	  @building_drawing_area.set_add_building_type(button.building_class)
	end
	
	add_high_tech_industrial_facility_button = BuildingToolRadioButton.new(HighTechIndustrialFacility)
	self.append_custom_tool_button(add_high_tech_industrial_facility_button)
	add_high_tech_industrial_facility_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("add_building")
	  @building_drawing_area.set_add_building_type(button.building_class)
	end
	
	add_extractor_button = BuildingToolRadioButton.new(Extractor)
	self.append_custom_tool_button(add_extractor_button)
	add_extractor_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("add_building")
	  @building_drawing_area.set_add_building_type(button.building_class)
	end
	
	add_extractor_head_button = Gtk::RadioToolButton.new
	add_extractor_head_button.icon_widget = Gtk::Image.new(:file => "view/images/16x16/extractor_head_icon.png")
	add_extractor_head_button.label = "Add Extractor Head..."
	self.append_custom_tool_button(add_extractor_head_button)
	add_extractor_head_button.signal_connect('clicked') do |button|
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
	
	
	# Link Creation and Deletion
	#
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
	
	
	# Read the state of the building drawing area's on click action.
	# Set the appropriate button to active.
	case (@building_drawing_area.on_click_action)
	when "add_building"
	  selected_class = @building_drawing_area.add_building_class
	  case (selected_class)
	  when CommandCenter
		add_command_center_button.active = true
		
	  when StorageFacility
		add_storage_facility_button.active = true
		
	  when Launchpad
		add_launchpad_button.active = true
		
	  when BasicIndustrialFacility
		add_basic_industrial_facility_button.active = true
		
	  when AdvancedIndustrialFacility
		add_advanced_industrial_facility_button.active = true
		
	  when HighTechIndustrialFacility
		add_high_tech_industrial_facility_button.active = true
		
	  when Extractor
		add_extractor_button.active = true
	  end
	  
	  
	when "add_extractor_head"
	  add_extractor_button.active = true
	  
	when "move_building"
	  move_tool_button.active = true
	  
	when "edit_building"
	  edit_building_button.active = true
	  
	when "delete_building"
	  delete_building_button.active = true
	  
	when "add_link"
	  add_link_button.active = true
	  
	when "edit_link"
	  edit_link_button.active = true
	  
	when "delete_link"
	  remove_link_button.active = true
	  
	when "expedited_transfer"
	  expedited_transfer_button.active = true
	end
	
	return self
  end
end