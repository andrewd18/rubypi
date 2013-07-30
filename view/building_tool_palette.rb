require_relative 'radio_button_tool_palette.rb'
require_relative 'building_tool_radio_button.rb'

class BuildingToolPalette < RadioButtonToolPalette
  def initialize(building_drawing_area)
	super()
	
	@building_drawing_area = building_drawing_area
	
	self.orientation=(:vertical)
	self.toolbar_style=(Gtk::Toolbar::Style::BOTH_HORIZ)
	
	# Add all the various tools I'm going to want.
	#
	# Add <building> Tool
	#  - one for each
	# Move Building Tool
	# Delete Building Tool
	# Select Building Toold
	
	building_class_names = Array.new
	building_class_names << CommandCenter
	building_class_names << StorageFacility
	building_class_names << Launchpad
	building_class_names << Extractor
	building_class_names << BasicIndustrialFacility
	building_class_names << AdvancedIndustrialFacility
	building_class_names << HighTechIndustrialFacility
	
	building_class_names.each do |class_name|
	  button = BuildingToolRadioButton.new(class_name)
	  self.append_custom_tool_button(button)
	  
	  button.signal_connect('clicked') do |button|
		@building_drawing_area.set_on_click_action("add_building")
		@building_drawing_area.set_add_building_type(button.building_class)
	  end
	end
	
	move_tool_button = Gtk::RadioToolButton.new
	move_tool_button.label = "Move Building"
	self.append_custom_tool_button(move_tool_button)
	move_tool_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("move_building")
	end
	
	edit_building_button = Gtk::RadioToolButton.new
	edit_building_button.label = "Edit Building"
	self.append_custom_tool_button(edit_building_button)
	edit_building_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("edit_building")
	end
	
	delete_building_button = Gtk::RadioToolButton.new
	delete_building_button.label = "Delete Building"
	self.append_custom_tool_button(delete_building_button)
	delete_building_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("delete_building")
	end
	
	add_link_button = Gtk::RadioToolButton.new
	add_link_button.label = "Add Link"
	self.append_custom_tool_button(add_link_button)
	add_link_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("add_link")
	end
	
	remove_link_button = Gtk::RadioToolButton.new
	remove_link_button.label = "Delete Link"
	self.append_custom_tool_button(remove_link_button)
	remove_link_button.signal_connect('clicked') do |button|
	  @building_drawing_area.set_on_click_action("delete_link")
	end
	
	# Set the default action.
	edit_building_button.active = true
	@building_drawing_area.set_on_click_action("edit_building")
	
	# And set a size request.  min_width, min_height
	puts "#{self.children.count}"
	self.set_size_request(1, (32 * self.children.count))
	
	return self
  end
end