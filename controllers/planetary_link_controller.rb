require_relative '../view/planetary_link_view/planetary_link_view.rb'

class PlanetaryLinkController
  
  attr_reader :view
  
  def initialize(link_model)
	# Store the model.
	@link_model = link_model
	
	@view = PlanetaryLinkView.new(self)
	@view.link_model = @link_model
	
	# Begin observing the model.
	self.start_observing_model
  end
  
  # Actions the view can call.
  def change_upgrade_level(new_level)
	@link_model.upgrade_level=(new_level)
  end
  
  def up_to_planet_controller
	$ruby_pi_main_gtk_window.load_controller_for_model(@link_model.planet)
  end
  
  
  # Model observation methods.
  def start_observing_model
	@link_model.add_observer(self, "on_model_changed")
  end
  
  def stop_observing_model
	@link_model.delete_observer(self)
  end
  
  def on_model_changed
	# Pass the model up to the view.
	@view.link_model = @link_model
  end
  
  # Destructor.
  def destroy
	self.stop_observing_model
	
	# Destroy the view.
	@view.destroy
  end
end