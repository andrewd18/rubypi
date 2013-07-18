require_relative 'radio_button_tool_palette.rb'

class BuildingToolPalette < RadioButtonToolPalette
  def initialize
	super()
	
	self.orientation=(:vertical)
	
	# Add all the various tools I'm going to want.
	#
	# Add <building> Tool
	#  - one for each
	# Move Building Tool
	# Delete Building Tool
	# Select Building Toold
	
	
	
	
	self.append_custom_tool_button("../rubypi/view/images/64x64/command_center_icon.png", "CommandCenter")
	self.append_custom_tool_button("../rubypi/view/images/64x64/extractor_icon.png", "Extractor")
	self.append_custom_tool_button("../rubypi/view/images/64x64/industrial_facility_two_materials.png", "BasicIndustrialFacility")
	
	# tool.signal_connect('clicked') do |tool|
	#   # do something
	# end
	
	return self
  end
end