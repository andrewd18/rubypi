require 'gtk3'

require_relative 'building_tool_palette.rb'
require_relative 'building_drawing_area.rb'

class BuildingLayoutWidget < Gtk::Frame
  def initialize(controller)
	# Create a Gtk::Frame.
	super()
	
	@controller = controller
	
	# Create a drawing area and a tool palette linked to it.
	@building_drawing_area = BuildingDrawingArea.new(@controller)
	@drawing_tool_palette = BuildingToolPalette.new(@building_drawing_area)
	
	hbox = Gtk::Box.new(:horizontal)
	hbox.pack_start(@drawing_tool_palette, :expand => false)
	hbox.pack_start(@building_drawing_area, :expand => true, :fill => true)
	self.add(hbox)
	
	self.show_all
	
	return self
  end
  
  def planet_model=(new_planet_model)
	# Pass the new model to the drawing area.
	@building_drawing_area.planet_model = new_planet_model
  end
end