require_relative '../view/pi_configuration_view/pi_configuration_view.rb'

class PIConfigurationController
  
  attr_reader :view
  
  def initialize(pi_configuration_model)
	# Store the model.
	@pi_configuration_model = pi_configuration_model
	
	# Create the view.
	@view = PIConfigurationView.new(self)
	@view.pi_configuration_model = @pi_configuration_model
	
	# Begin observing the model.
	self.start_observing_model
  end
  
  # Actions the view can call.
  def add_gas_planet
	@pi_configuration_model.add_planet(Planet.new("Gas"))
  end
  
  def add_ice_planet
	@pi_configuration_model.add_planet(Planet.new("Ice"))
  end
  
  def add_storm_planet
	@pi_configuration_model.add_planet(Planet.new("Storm"))
  end
  
  def add_barren_planet
	@pi_configuration_model.add_planet(Planet.new("Barren"))
  end
  
  def add_temperate_planet
	@pi_configuration_model.add_planet(Planet.new("Temperate"))
  end
  
  def add_lava_planet
	@pi_configuration_model.add_planet(Planet.new("Lava"))
  end
  
  def add_oceanic_planet
	@pi_configuration_model.add_planet(Planet.new("Oceanic"))
  end
  
  def add_plasma_planet
	@pi_configuration_model.add_planet(Planet.new("Plasma"))
  end
  
  def remove_planet(planet_instance)
	@pi_configuration_model.remove_planet(planet_instance)
  end
  
  def edit_selected_planet(planet_instance)
	$ruby_pi_main_gtk_window.load_controller_for_model(planet_instance)
  end
  
  
  # Model observation methods.
  def start_observing_model
	@pi_configuration_model.add_observer(self, "on_model_changed")
  end
  
  def stop_observing_model
	@pi_configuration_model.delete_observer(self)
  end
  
  def on_model_changed
	# Pass a duplicated, frozen model up to the view so the view can't directly change it.
	duplicated_model = @pi_configuration_model.dup
	frozen_model = duplicated_model.freeze
	
	@view.pi_configuration_model = frozen_model
  end
  
  # Destructor.
  def destroy
	self.stop_observing_model
	
	# Destroy the view.
	@view.destroy
  end
end