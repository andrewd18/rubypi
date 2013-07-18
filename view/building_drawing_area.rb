require 'gtk3'

require_relative 'cairo_building_image.rb'
require_relative 'cairo_link_image.rb'

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

class BuildingDrawingArea < Gtk::DrawingArea
  def initialize(planet_model, palette)
	# Set up GTK stuffs.
	super()
	
	@planet_model = planet_model
	@palette = palette
	
	@x_coord = nil
	@y_coord = nil
	
	# Set up auto-refresh of drawing area.
	self.signal_connect('draw') do |widget, cairo_context|
	  self.draw_all(widget, cairo_context)
	end
	
	self.add_events(Gdk::Event::Mask::POINTER_MOTION_MASK)
	self.signal_connect('motion-notify-event') do |widget, event|
	  set_tool_outline_coords(widget, event)
	end
	
	self.add_events(Gdk::Event::Mask::LEAVE_NOTIFY_MASK)
	self.signal_connect('leave-notify-event') do |widget, event|
	  clear_tool_outline_coords(widget, event)
	end
	
	self.add_events(Gdk::Event::Mask::BUTTON_PRESS_MASK)
	self.signal_connect('button-press-event') do |widget, event|
	  add_building_to_model(widget, event)
	end
  end
  
  def draw_all(widget, cairo_context)
	# Draw from back to front.
	# LINKS
	@planet_model.links.each do |link|
	  image = CairoLinkImage.new(link)
	  image.draw(cairo_context)
	end
	
	# BUILDINGS
	@planet_model.buildings.each do |building|
	  image = CairoBuildingImage.new(building, 64, 64)
	  image.draw(cairo_context)
	end
	
	cairo_context.save do
	  # If the mouse is over the drawing area, 
	  # draw a faint image of the selected palette tool at the pointer coordinates.
	  
	  if ((@x_coord != nil) &&
		  (@y_coord != nil))
		
		image_to_display = @palette.active_tool.icon_widget.pixbuf
		# HACK: Assumes 64x64 image.
		cairo_context.translate(@x_coord - 32, @y_coord - 32)
		cairo_context.set_source_pixbuf(image_to_display)
		cairo_context.paint
	  end
	end
  end
  
  private
  
  def set_tool_outline_coords(widget, event)
	@x_coord = event.x
	@y_coord = event.y
	
	# Force a redraw of the widget.
	self.queue_draw
  end
  
  def clear_tool_outline_coords(widget, event)
	@x_coord = nil
	@y_coord = nil
	
	# Force a redraw of the widget.
	self.queue_draw
  end
  
  def add_building_to_model(widget, event)
	building_x_pos = event.x
	building_y_pos = event.y
	
	# HACK: Assumes the name shown will be a class.
	# HACK: Module.const_get is a bad idea.
	class_name = Module.const_get(@palette.active_tool.label_widget.text)
	building_instance = class_name.new(@x_coord, @y_coord)
	@planet_model.add_building(building_instance)
  end
end