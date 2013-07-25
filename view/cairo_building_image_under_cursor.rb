require_relative 'cairo_building_image.rb'

# Given a building model, can draw an image of it to a Cairo context.

class CairoBuildingImageUnderCursor < CairoBuildingImage
  
  attr_accessor :will_overlap
  
  def initialize(building_model, width, height)
	super
	
	@will_overlap = true
  end
  
  def draw(cairo_context)
	# Do all the painting in a transaction.
	cairo_context.save do
	  # Move to the x/y coordinate that starts the top left corner of the scaled image.
	  cairo_context.translate(self.top_left_x_coord, self.top_left_y_coord)
	  
	  # Paint the pixbuf to the target.
	  cairo_context.set_source_pixbuf(@image)
	  cairo_context.paint
	  
	  # Draw red overlay if necessary.
	  if (@will_overlap == true)
		
		red   = (255.0 / 255)
		green = (0.0 / 255)
		blue  = (0.0 / 255)
		alpha = (160.0 / 255)
		
		cairo_context.save do
		  # Cairo Full Circle:
		  # cairo_context.arc(center x_pos, center y_pos, radius, 0, (2 * Math::PI))
		  cairo_context.arc((@width / 2), (@height / 2), (@width / 2), 0, (2 * Math::PI))
		  cairo_context.set_source_rgba(red, green, blue, alpha)
		  cairo_context.fill
		end
	  end
	end
  end
end