require 'gtk3'

require_relative 'building_tool_palette.rb'
require_relative 'building_drawing_area.rb'
require_relative 'building_drawing_area_settings_widget.rb'

class BuildingLayoutWidget < Gtk::Frame
  def initialize(controller)
	# Create a Gtk::Frame.
	super()
	
	@controller = controller
	
	# Create a drawing area and a tool palette linked to it.
	@building_drawing_area = BuildingDrawingArea.new(@controller)
	@building_drawing_area_settings_widget = BuildingDrawingAreaSettingsWidget.new(@building_drawing_area)
	@drawing_tool_palette = BuildingToolPalette.new(@building_drawing_area)
	
	drawing_area_vbox = Gtk::Box.new(:vertical)
	drawing_area_vbox.pack_start(@building_drawing_area, :expand => true)
	drawing_area_vbox.pack_start(@building_drawing_area_settings_widget, :expand => false)
	drawing_area_frame = Gtk::Frame.new
	drawing_area_frame.add(drawing_area_vbox)
	
	hbox = Gtk::Box.new(:horizontal)
	hbox.pack_start(@drawing_tool_palette, :expand => false)
	hbox.pack_start(drawing_area_frame, :expand => true, :fill => true)
	
	self.add(hbox)
	
	self.show_all
	
	return self
  end
  
  def planet_model=(new_planet_model)
	# Pass the new model to the drawing area.
	@building_drawing_area.planet_model = new_planet_model
  end
end