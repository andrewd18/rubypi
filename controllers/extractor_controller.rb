require_relative '../view/extractor_view/extractor_view.rb'

class ExtractorController
  
  attr_reader :view
  
  def initialize(building_model)
	# Store the model.
	@building_model = building_model
	
	@view = ExtractorView.new(self)
	@view.building_model = @building_model
	
	# Begin observing the model.
	self.start_observing_model
  end
  
  # Actions the view can call.
  def set_extracted_product_name(new_product_name)
	@building_model.product_name = new_product_name
  end
  
  def set_extracted_quantity(new_quantity)
	@building_model.quantity_extracted_per_hour = new_quantity
  end
  
  def set_output_building(new_building)
	@building_model.production_cycle_output_building = new_building
  end
  
  def set_extraction_time_scale(new_value)
	@building_model.extraction_time_in_hours = new_value
  end
  
  def up_to_planet_controller
	$ruby_pi_main_gtk_window.load_controller_for_model(@building_model.planet)
  end
  
  
  # Model observation methods.
  def start_observing_model
	@building_model.add_observer(self, "on_model_changed")
  end
  
  def stop_observing_model
	@building_model.delete_observer(self)
  end
  
  def on_model_changed
	# Pass the building model up to the view.
	@view.building_model = @building_model
  end
  
  # Destructor.
  def destroy
	self.stop_observing_model
	
	# Destroy the view.
	@view.destroy
  end
end