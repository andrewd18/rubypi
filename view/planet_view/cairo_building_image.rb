# Given a building model, can draw an image of it to a Cairo context.

class CairoBuildingImage
  
  PATH_TO_IMAGES_FOLDER = "view/images"
  
  NAME_TO_FILENAME = { "Command Center" => "command_center_icon.png",
                       "Extractor" => "extractor_icon.png",
                       "Storage Facility" => "storage_facility_icon.png",
                       "Launchpad" => "launchpad_icon.png",
                       "Basic Industrial Facility" => "industrial_facility_two_materials.png",
                       "Advanced Industrial Facility" => "industrial_facility_two_materials.png",
                       "High Tech Industrial Facility" => "industrial_facility_three_materials.png",
                       "Extractor Head" => "extractor_head_icon.png",
                       "Customs Office" => "poco_icon.png"}
  
  attr_reader :image
  attr_accessor :invalid_position
  attr_accessor :highlighted
  
  def initialize(building_model, width, height)
	raise ArgumentError unless building_model.is_a?(PlanetaryBuilding)
	
	@building_model = building_model
	
	# Determine which image to use.
	# TODO - Clean this up.
	if (@building_model.is_a?(BasicIndustrialFacility) or
	    @building_model.is_a?(AdvancedIndustrialFacility) or
	    @building_model.is_a?(HighTechIndustrialFacility))
	  
	  # Calculate a filename based on schematic.
	  if (@building_model.schematic == nil)
		# No schematic set. Use default image.
		filename = "#{PATH_TO_IMAGES_FOLDER}" + "/" + "#{width}x#{height}" + "/" + "#{NAME_TO_FILENAME[@building_model.name]}"
	  else
		base_filename = "#{PATH_TO_IMAGES_FOLDER}" + "/" + "#{width}x#{height}" + "/"
		
		image_by_p_level_and_inputs = "industrial_facility_p" + "#{@building_model.schematic.p_level}_#{@building_model.schematic.inputs.count}" + "_mat.png"
		
		filename = base_filename + image_by_p_level_and_inputs
	  end
	else
	  filename = "#{PATH_TO_IMAGES_FOLDER}" + "/" + "#{width}" + "x" + "#{height}" + "/" + "#{NAME_TO_FILENAME[@building_model.name]}"
	end
	
	raise "#{filename} not found." unless File.exists?(filename)
	
	# WORKAROUND:
	# So, I really wanted to use SVGs and scale them on the fly.
	# The RSVG library says to use RSVG::Handle.new_from_file(filename). However, the GC never releases it.
	# This causes crazy memory allocation issues.
	# So instead I resort to using pixbufs. Sigh.
	@image = Gdk::Pixbuf.new(filename, width, height)
	@width = width
	@height = height
	@invalid_position = false
	@highlighted = false
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
	  # Move to the x/y coordinate that starts the top left corner of the scaled image.
	  cairo_context.translate(self.top_left_x_coord, self.top_left_y_coord)
	  
	  # Scale the base image.
	  cairo_context.scale(self.horizontal_scale, self.vertical_scale)
	  
	  # Paint the image to the target.
	  cairo_context.set_source_pixbuf(@image)
	  cairo_context.paint
	end
	
	# Draw overlays if necessary.
	if (@invalid_position == true)
	  
	  red   = (255.0 / 255)
	  green = (0.0 / 255)
	  blue  = (0.0 / 255)
	  alpha = (160.0 / 255)
	  
	  cairo_context.save do
		# Move to the x/y coordinate that starts the top left corner of the scaled image.
		cairo_context.translate(self.top_left_x_coord, self.top_left_y_coord)
		
		# Cairo Full Circle:
		# cairo_context.arc(center x_pos, center y_pos, radius, 0, (2 * Math::PI))
		cairo_context.arc((@width / 2), (@height / 2), (@width / 2), 0, (2 * Math::PI))
		cairo_context.set_source_rgba(red, green, blue, alpha)
		cairo_context.fill
	  end
	end
	
	if (@highlighted == true)
	  # If highlighted, surround it with a green ring.
	  
	  red   = (0.0 / 255)
	  green = (255.0 / 255)
	  blue  = (0.0 / 255)
	  alpha = (160.0 / 255)
	  
	  cairo_context.save do
		# Move to the x/y coordinate that starts the top left corner of the scaled image.
		cairo_context.translate(self.top_left_x_coord, self.top_left_y_coord)
		
		# The ring should be #{buffer} pixels outside the actual image.
		buffer = 5
		
		# Cairo Full Circle:
		# cairo_context.arc(center x_pos, center y_pos, radius, 0, (2 * Math::PI))
		cairo_context.arc((@width / 2), (@height / 2), ((@width / 2) + buffer), 0, (2 * Math::PI))
		cairo_context.set_source_rgba(red, green, blue, alpha)
		cairo_context.stroke
	  end
	end
	
  end
end