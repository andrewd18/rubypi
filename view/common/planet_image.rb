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
  
  def initialize(planet_model = nil, requested_size_array_in_px = [64, 64])
	@planet_model = planet_model
	
	@requested_width = requested_size_array_in_px[0]
	@requested_height = requested_size_array_in_px[1]
	
	super(:file => calculate_filename)
	
	self.set_size_request(@requested_width, @requested_height)
	
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
	  return "#{BASE_IMAGES_FOLDER}" + "/" + "#{@requested_width}x#{@requested_height}" + "/uncolonized_planet.png"
	else
	  return "#{BASE_IMAGES_FOLDER}" + "/" + "#{@requested_width}x#{@requested_height}" + "/" + "#{TYPE_TO_FILENAME[@planet_model.type]}"
	end
  end
end