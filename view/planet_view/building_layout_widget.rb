require 'gtk3'

require_relative 'building_tool_palette.rb'
require_relative 'building_drawing_area.rb'



# CREATE
# On-click, adds selected building type to model at location.
# On-hover, shows selected building type under cursor, faded out.
# On-hover, shows selected building type under cursor, red-shaded if coordinates taken.

# READ
# Draws each building
# Draws each link

# UPDATE / EDIT
# On model change, update all.

# DESTROY
# On <something> remove building and connected links from the model.

class BuildingLayoutWidget < Gtk::Frame
  def initialize(controller)
	super()
	
	@controller = controller
	
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
	@building_drawing_area.planet_model = new_planet_model
  end
end