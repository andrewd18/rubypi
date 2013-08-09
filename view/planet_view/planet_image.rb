require 'gtk3'

# Changes the image of the planet based off of its model type.

class PlanetImage < Gtk::Image
  
  BASE_IMAGES_FOLDER = "view/images"
  
  TYPE_TO_FILENAME = {"Gas" => "gas_planet.png",
                      "Ice" => "ice_planet.png",
                      "Storm" => "storm_planet.png",
                      "Barren" => "barren_planet.png",
                      "Temperate" => "temperate_planet.png",
                      "Lava" => "lava_planet.png",
                      "Oceanic" => "oceanic_planet.png",
                      "Plasma" => "plasma_planet.png"}
  
  def initialize(requested_size_array_in_px = [64, 64])
	@requested_width_in_text = "#{requested_size_array_in_px[0]}"
	@requested_height_in_text = "#{requested_size_array_in_px[1]}"
	
	super(:file => calculate_filename)
	
	return self
  end
  
  # Called when the @planet_model changes.
  def planet_model=(new_planet_model)
	@planet_model = new_planet_model
	
	self.file = calculate_filename
  end
  
  private
  
  def calculate_filename
	if (@planet_model == nil)
	  return "#{BASE_IMAGES_FOLDER}" + "/" + "#{@requested_width_in_text}x#{@requested_height_in_text}" + "/uncolonized_planet.png"
	else
	  return "#{BASE_IMAGES_FOLDER}" + "/" + "#{@requested_width_in_text}x#{@requested_height_in_text}" + "/" + "#{TYPE_TO_FILENAME[@planet_model.type]}"
	end
  end
end