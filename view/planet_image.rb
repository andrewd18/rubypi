require 'gtk3'

# Changes the image of the planet based off of its model type.

class PlanetImage < Gtk::Image
  
  attr_accessor :planet_model
  
  BASE_IMAGES_FOLDER = "view/images"
  
  # TODO - Complete images for Ice and Plasma.
  TYPE_TO_FILENAME = {"Uncolonized" => "uncolonized_planet.png",
                      "Gas" => "gas_planet.png",
                      "Ice" => "ice_planet.png",
                      "Storm" => "storm_planet.png",
                      "Barren" => "barren_planet.png",
                      "Temperate" => "temperate_planet.png",
                      "Lava" => "lava_planet.png",
                      "Oceanic" => "oceanic_planet.png",
                      "Plasma" => "plasma_planet.png"}
  
  def initialize(planet_model, requested_size_array_in_px = [64, 64])
	@planet_model = planet_model
	
	@displayed_type = @planet_model.type
	
	@requested_width_in_text = "#{requested_size_array_in_px[0]}"
	@requested_height_in_text = "#{requested_size_array_in_px[1]}"
	
	super(:file => calculate_filename)
	
	return self
  end
  
  def start_observing_model
	@planet_model.add_observer(self)
  end
  
  def stop_observing_model
	@planet_model.delete_observer(self)
  end
  
  # Called when the @planet_model changes.
  def update
	# If the two types don't match, the user has changed the model type. We need to update the image.
	if (@displayed_type != @planet_model.type)
	  @displayed_type = @planet_model.type
	  
	  # Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	  unless (self.destroyed?)
		self.file = calculate_filename
	  end
	end
  end
  
  def destroy
	self.stop_observing_model
	
	super
  end
  
  private
  
  def calculate_filename
	return "#{BASE_IMAGES_FOLDER}" + "/" + "#{@requested_width_in_text}x#{@requested_height_in_text}" + "/" + "#{TYPE_TO_FILENAME[@displayed_type]}"
  end
end