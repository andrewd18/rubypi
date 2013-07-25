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
	  
	  if (@will_overlap == true)
		# Create a red see-through surface below the pixbuf.
		red   = (255.0 / 255)
		green = (0.0 / 255)
		blue  = (0.0 / 255)
		alpha = (160.0 / 255)
		
		cairo_context.save do
		  # No need to move again because we're in a child of the already translated context.
		  cairo_context.rectangle(0, 0, @width, @height)
		  cairo_context.set_source_rgba(red, green, blue, alpha)
		  cairo_context.fill
		end
	  end
	  
	  # Paint the pixbuf to the target.
	  cairo_context.set_source_pixbuf(@image)
	  cairo_context.paint
	end
  end
end