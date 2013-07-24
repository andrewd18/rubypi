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
  
  BUILDING_ICON_SIZE = 64
  
  def initialize(planet_model)
	# Set up GTK stuffs.
	super()
	
	@planet_model = planet_model
	@building_under_cursor = nil
	
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
  
  def change_building_under_cursor(building_class)
	@building_under_cursor = building_class.new(nil, nil)
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
	  image = CairoBuildingImage.new(building, BUILDING_ICON_SIZE, BUILDING_ICON_SIZE)
	  image.draw(cairo_context)
	end
	
	cairo_context.save do
	  # If the mouse is over the drawing area, 
	  # draw a faint image of the selected palette tool at the pointer coordinates.
	  
	  if ((@building_under_cursor.x_pos != nil) &&
		  (@building_under_cursor.y_pos != nil))
		image = CairoBuildingImage.new(@building_under_cursor, BUILDING_ICON_SIZE, BUILDING_ICON_SIZE)
		image.draw(cairo_context)
	  end
	end
  end
  
  private
  
  def set_tool_outline_coords(widget, event)
	@building_under_cursor.x_pos = event.x
	@building_under_cursor.y_pos = event.y
	
	# Force a redraw of the widget.
	self.queue_draw
  end
  
  def clear_tool_outline_coords(widget, event)
	@building_under_cursor.x_pos = nil
	@building_under_cursor.y_pos = nil
	
	# Force a redraw of the widget.
	self.queue_draw
  end
  
  def add_building_to_model(widget, event)
	# Copy the values of @building_under_cursor
	new_building = @building_under_cursor.class.new(@building_under_cursor.x_pos, @building_under_cursor.y_pos)
	
	begin
	  @planet_model.add_building(new_building)
	rescue ArgumentError => error
	  # TODO - Tell the user what happened nicely.
	  # For now, spit it out to the command line.
	  puts error
	end
	
	# Force a redraw of the widget.
	self.queue_draw
  end
end