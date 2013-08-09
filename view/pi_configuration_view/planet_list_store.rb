class PlanetListStore < Gtk::ListStore
  
  # HACK
  # I should really change PlanetImage to not mandate a planet instance and then use that here.
  
  TYPE_TO_FILENAME = {"Gas" => "gas_planet.png",
                      "Ice" => "ice_planet.png",
                      "Storm" => "storm_planet.png",
                      "Barren" => "barren_planet.png",
                      "Temperate" => "temperate_planet.png",
                      "Lava" => "lava_planet.png",
                      "Oceanic" => "oceanic_planet.png",
                      "Plasma" => "plasma_planet.png"}
  
  
  def initialize(pi_configuration_model)
	
	super(Planet,       # Planet Instance
		  Gdk::Pixbuf,	# Icon
	      String,		# Name
	      String,		# Text form of Percent PG Usage
	      Integer,		# Percent of PG Usage progress bar to fill (as it can't take values > 100)
	      String,		# Text form of Percent CPU Usage
	      Integer,		# Percent of CPU Usage progress bar to fill (as it can't take values > 100)
	      Integer,		# Number of Extractors
	      Integer,		# Number of Factories
	      Integer,		# Number of Storages
	      Integer		# Number of Launchpads
	      )
	
	# Link to the model.
	@pi_configuration_model = pi_configuration_model
	
	# Populate self from model.
	self.update
	
	return self
  end
  
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @pi_configuration_model.planets.each do |planet|
		new_planet_row = self.append
		new_planet_row.set_value(0, planet)
		new_planet_row.set_value(1, Gtk::Image.new(:file => calculate_planet_image_filename(planet.type)).pixbuf)
		new_planet_row.set_value(2, planet.name)
		
		# Value of text in progress bar. Round to 2 digits.
		new_planet_row.set_value(3, "#{planet.pct_powergrid_usage.round(2)} %")
		
		# Amount to fill progress bar. Must be an Int or GTK gets mad.
		if (planet.pct_powergrid_usage > 100)
		  new_planet_row.set_value(4, 100)
		else
		  new_planet_row.set_value(4, planet.pct_powergrid_usage.to_int)
		end
		
		# Value of text in progress bar. Round to 2 digits.
		new_planet_row.set_value(5, "#{planet.pct_cpu_usage.round(2)} %")
		
		# Amount to fill progress bar. Must be an Int or GTK gets mad.
		if (planet.pct_cpu_usage > 100)
		  new_planet_row.set_value(6, 100)
		else
		  new_planet_row.set_value(6, planet.pct_cpu_usage.to_int)
		end
		
		new_planet_row.set_value(7, planet.num_extractors)
		new_planet_row.set_value(8, planet.num_factories)
		new_planet_row.set_value(9, planet.num_storages)
		new_planet_row.set_value(10, planet.num_launchpads)
	  end
	end
  end

  def calculate_planet_image_filename(planet_type)
	return "view/images/32x32/" + "#{TYPE_TO_FILENAME[planet_type]}"
  end
end