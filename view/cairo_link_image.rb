require 'rsvg2'

# Given a planetary link model, can draw an image of it to a Cairo context.

class CairoLinkImage
  def initialize(link_model)
	raise ArgumentError unless link_model.is_a?(PlanetaryLink)
	@link = link_model
  end
  
  def draw(cairo_context)
	# Do all the painting in a transaction.
	cairo_context.save do
	  # Black
	  cairo_context.set_source_rgba(0.0, 0.0, 0.0, 1.0)
	  cairo_context.set_line_width(2.0)
	  
	  # Move to the coordinates for this slot.
	  cairo_context.move_to(@link.start_x_pos, @link.start_y_pos)
	  
	  # Draw a line to the connected slot.
	  cairo_context.line_to(@link.end_x_pos, @link.end_y_pos)
	  
	  cairo_context.stroke
	end
  end
end