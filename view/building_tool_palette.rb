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
	
	
	return self
  end
end