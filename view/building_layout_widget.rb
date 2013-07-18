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

class BuildingLayoutWidget < Gtk::DrawingArea
  def initialize(planet_model)
	# Set up GTK stuffs.
	super()
	
	@planet_model = planet_model
	
	@x_coord = nil
	@y_coord = nil
	
	# Set up auto-refresh of drawing area.
	self.signal_connect('draw') do |widget, cairo_context|
	  self.draw_all(widget, cairo_context)
	end
	
	self.add_events(Gdk::Event::Mask::POINTER_MOTION_MASK)
	self.signal_connect('motion-notify-event') do |widget, event|
	  set_square_coords(widget, event)
	end
	
	self.add_events(Gdk::Event::Mask::LEAVE_NOTIFY_MASK)
	self.signal_connect('leave-notify-event') do |widget, event|
	  clear_square_coords(widget, event)
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
	
	# Square at pointer.
	cairo_context.save do
	  if (@x_coord != nil)
		# Black
		cairo_context.set_source_rgba(0.0, 0.0, 0.0, 1.0)
		cairo_context.set_line_width(2.0)
		
		# x, y, width, height
		cairo_context.rectangle((@x_coord - 32), (@y_coord - 32), 64, 64)
		
		cairo_context.stroke
	  end
	end
  end
  
  private
  
  def set_square_coords(widget, event)
	@x_coord = event.x
	@y_coord = event.y
	
	# Force a redraw of the widget.
	self.queue_draw
  end
  
  def clear_square_coords(widget, event)
	@x_coord = nil
	@y_coord = nil
	
	# Force a redraw of the widget.
	self.queue_draw
  end
  
  def add_building_to_model(widget, event)
	building_x_pos = event.x
	building_y_pos = event.y
	
	puts "#{[building_x_pos, building_y_pos]}"
  end
end