require 'gtk3'

require_relative 'building_tool_palette.rb'
require_relative 'building_drawing_area.rb'
require_relative 'building_drawing_area_status_widget.rb'

class BuildingLayoutWidget < Gtk::Frame
  def initialize(controller)
	# Create a Gtk::Frame.
	super()
	
	@controller = controller
	
	# Create a drawing area and a tool palette linked to it.
	@building_drawing_area = BuildingDrawingArea.new(@controller)
	@building_drawing_area_settings_widget = BuildingDrawingAreaStatusWidget.new(@building_drawing_area)
	@drawing_tool_palette = BuildingToolPalette.new(@building_drawing_area)
	
	drawing_tool_palette_window = Gtk::ScrolledWindow.new
	drawing_tool_palette_window.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	drawing_tool_palette_window.add_with_viewport(@drawing_tool_palette)
	
	
	# NOTE: Do not let the @building_drawing_area expand. It should be the size it requests and nothing more.
	# If the user's resolution is too small, let the viewport handle it with scrolling.
	drawing_area_viewport = Gtk::ScrolledWindow.new
	drawing_area_viewport.set_policy(Gtk::PolicyType::AUTOMATIC, Gtk::PolicyType::AUTOMATIC)
	drawing_area_viewport.add_with_viewport(@building_drawing_area)
	
	
	drawing_area_vbox = Gtk::Box.new(:vertical)
	drawing_area_vbox.pack_start(drawing_area_viewport, :expand => true)
	drawing_area_vbox.pack_end(@building_drawing_area_settings_widget, :expand => false)
	
	
	hbox = Gtk::Box.new(:horizontal)
	hbox.pack_start(drawing_tool_palette_window, :expand => false)
	hbox.pack_start(drawing_area_vbox, :expand => true, :fill => true)
	
	self.add(hbox)
	
	self.show_all
	
	return self
  end
  
  def planet_model=(new_planet_model)
	# Pass the new model to the drawing area.
	@building_drawing_area.planet_model = new_planet_model
  end
end