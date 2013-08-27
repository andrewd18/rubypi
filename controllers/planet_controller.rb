require_relative '../view/planet_view/planet_view.rb'

class PlanetController
  
  attr_reader :view
  
  def initialize(planet_model)
	# Store the model.
	@planet_model = planet_model
	
	# Create the view.
	@view = PlanetView.new(self)
	@view.planet_model = @planet_model
	
	# Begin observing the model.
	self.start_observing_model
  end
  
  # Actions the view can call.
  def add_building(new_building)
	begin
	  @planet_model.add_building(new_building)
	rescue ArgumentError => error
	  # TODO - Tell the user what happened nicely.
	  # For now, spit it out to the command line.
	  puts error
	end
  end
  
  def delete_building(building_to_remove)
	if (building_to_remove.is_a?(ExtractorHead))
	  parent_extractor = building_to_remove.extractor
	  parent_extractor.remove_extractor_head(building_to_remove)
	else
	  @planet_model.remove_building(building_to_remove)
	end
  end
  
  def add_extractor_head(parent_extractor, head_x_pos, head_y_pos)
	begin
	  parent_extractor.add_extractor_head(head_x_pos, head_y_pos)
	rescue RuntimeError => error
	  # TODO - Tell the user what happened nicely.
	  # For now, spit it out to the command line.
	  puts error
	end
  end
  
  def add_link(source_building, destination_building)
	begin
	  @planet_model.add_link(source_building, destination_building)
	rescue ArgumentError => error
	  # TODO - Tell the user what happened nicely.
	  # For now, spit it out to the command line.
	  puts error
	end
  end
  
  def edit_link(source_building, destination_building)
	link_to_edit = @planet_model.find_link(source_building, destination_building)
	$ruby_pi_main_gtk_window.load_controller_for_model(link_to_edit)
  end
  
  def set_link_length(source_building, destination_building, length)
	link_to_edit = @planet_model.find_link(source_building, destination_building)
	link_to_edit.length = length
  end
  
  def delete_link
	link_to_remove = @planet_model.find_link(source_building, destination_building)
	@planet_model.remove_link(link_to_remove)
  end
  
  def change_planet_type(new_type)
	# Only change the model if the passed in type is different from the model type.
	unless (@planet_model.type == new_type)
	  @planet_model.type = new_type
	end
  end
  
  def change_planet_name(new_name)
	# Only change the model if the passed in name is different from the model name.
	unless (@planet_model.name == new_name)
	  @planet_model.name = new_name
	end
  end
  
  def overwrite_planet_storage(product_quantity_hash, building_to_update)
	@planet_model.buildings.each do |known_building|
	  if (known_building == building_to_update)
		# Set its stored_products hash to the new hash.
		known_building.stored_products=(product_quantity_hash)
	  end
	end
  end
  
  def up_to_pi_configuration_controller
	$ruby_pi_main_gtk_window.load_controller_for_model(@planet_model.pi_configuration)
  end
  
  def edit_selected_building(building_instance)
	$ruby_pi_main_gtk_window.load_controller_for_model(building_instance)
  end
  
  
  # Model observation methods.
  def start_observing_model
	@planet_model.add_observer(self, "on_model_changed")
  end
  
  def stop_observing_model
	@planet_model.delete_observer(self)
  end
  
  def on_model_changed
	# Pass the model up to the view.
	@view.planet_model = @planet_model
  end
  
  # Destructor.
  def destroy
	self.stop_observing_model
	
	# Destroy the view.
	@view.destroy
  end
end