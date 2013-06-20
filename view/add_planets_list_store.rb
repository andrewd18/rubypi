require 'gtk3'
require_relative '../model/planet.rb'
require_relative 'planet_image.rb'

class AddPlanetsListStore < Gtk::ListStore
  
  # HACK
  # I should really change PlanetImage to not mandate a planet instance.
  
  TYPE_TO_FILENAME = {"Gas" => "gas_planet.png",
                      "Ice" => "ice_planet.png",
                      "Storm" => "storm_planet.png",
                      "Barren" => "barren_planet.png",
                      "Temperate" => "temperate_planet.png",
                      "Lava" => "lava_planet.png",
                      "Oceanic" => "oceanic_planet.png",
                      "Plasma" => "plasma_planet.png"}
  
  
  def initialize
	@requested_width_in_text = 32
	@requested_height_in_text = 32
	
	# Set up columns.
	super(Gdk::Pixbuf,	# Icon
	      String)
	
	
	# Populate list.
	TYPE_TO_FILENAME.each_pair do |planet_type, image_filename|
	  planet_instance = Planet.new(planet_type)
	  
	  new_row = self.append
	  new_row.set_value(0, Gtk::Image.new(:file => calculate_planet_image_filename(image_filename)).pixbuf)
	  new_row.set_value(1, planet_type)
	end
	
	return self
  end
  
  def calculate_planet_image_filename(image_filename)
	return "view/images/32x32/" + "#{image_filename}"
  end
end