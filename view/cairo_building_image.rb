require 'rsvg2'

# Given a building model, can draw an image of it to a Cairo context.

class CairoBuildingImage
  
  NAME_TO_FILENAME = { "Command Center" => "command_center_icon.svg",
                       "Extractor" => "extractor_icon.svg",
                       "Storage Facility" => "storage_facility_icon.svg",
                       "Launchpad" => "launchpad_icon.svg",
                       "Basic Industrial Facility" => "industrial_facility_two_materials.svg",
                       "Advanced Industrial Facility" => "industrial_facility_two_materials.svg",
                       "High Tech Industrial Facility" => "industrial_facility_three_materials.svg",
                       "Customs Office" => "poco_icon.svg"}
  
  
  def initialize(building_model, width, height)
	raise ArgumentError unless building_model.is_a?(PlanetaryBuilding)
	
	@building_model = building_model
	filename = NAME_TO_FILENAME[@building_model.name]
	@image = RSVG::Handle.new_from_file(filename)
	@width = width
	@height = height
  end
  
  def horizontal_scale
	# Take the requested width and divide it by the width of the image we're loading off the hard drive.
	return (@width / @image.width.to_f)
  end
  
  def vertical_scale
	# Take the requested height and divide it by the height of the image we're loading off the hard drive.
	return (@height / @image.height.to_f)
  end
  
  def top_left_x_coord
	# Take the center x position from the building_model and subtract half the width.
	return (@building_model.x_pos - (@width / 2))
  end
  
  def top_left_y_coord
	# Take the center y position from the building_model and subtract half the height.
	return (@building_model.y_pos - (@height / 2))
  end
  
  def draw(cairo_context)
	# Do all the painting in a transaction.
	cairo_context.save do
	  # Move to the x/y coordinate that will draw the center of our scaled image at the window centerpoint.
	  cairo_context.translate(@building_model.x_pos, @building_model.y_pos)
	  
	  # Scale the base image.
	  cairo_context.scale(self.horizontal_scale, self.vertical_scale)
	  
	  # Paint the SVG to the target.
	  @image.render_cairo(cairo_context)
	end
  end
end