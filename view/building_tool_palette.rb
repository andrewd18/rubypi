require_relative 'radio_button_tool_palette.rb'
require_relative 'building_tool_radio_button.rb'

require_relative '../model/command_center.rb'
require_relative '../model/extractor.rb'
require_relative '../model/basic_industrial_facility.rb'

class BuildingToolPalette < RadioButtonToolPalette
  def initialize(building_drawing_area)
	super()
	
	@building_drawing_area = building_drawing_area
	
	self.orientation=(:vertical)
	
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
		@building_drawing_area.change_building_under_cursor(button.building_class)
	  end
	end
	
	# HACK: I have to do this because I'm not initializing something properly.
	# Finally, update the drawing area's building class.
	@building_drawing_area.change_building_under_cursor(self.active_tool.building_class)
	
	return self
  end
end