# Changes the image of the building based off of its model type.

class BuildingImage < Gtk::Image
  
  BASE_IMAGES_FOLDER = "view/images"
  
  # TODO - Complete images for all the buildings.
  NAME_TO_FILENAME = {"Command Center" => "command_center_icon.png",
                      "Extractor" => "launchpad_icon.png",
                      "Storage Facility" => "storage_facility_icon.png",
                      "Launchpad" => "launchpad_icon.png",
                      "Basic Industrial Facility" => "industrial_facility_two_materials.png",
                      "Advanced Industrial Facility" => "industrial_facility_two_materials.png",
                      "High Tech Industrial Facility" => "launchpad_icon.png"}
  
  def initialize(building_model, requested_size_array_in_px = [64, 64])
	@building_model = building_model
	@building_model.add_observer(self)
	
	@displayed_type = @building_model.name
	
	@requested_width_in_text = "#{requested_size_array_in_px[0]}"
	@requested_height_in_text = "#{requested_size_array_in_px[1]}"
	
	super(:file => calculate_filename)
	
	return self
  end
  
  # Called when the @building_model changes.
  def update
	# If the two types don't match, the user has changed the model type. We need to update the image.
	if (@displayed_type != @building_model.name)
	  @displayed_type = @building_model.name
	  
	  # Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	  unless (self.destroyed?)
		self.file = calculate_filename
	  end
	end
  end
  
  def destroy
	@building_model.delete_observer(self)
	
	super
  end
  
  private
  
  def calculate_filename
	return "#{BASE_IMAGES_FOLDER}" + "/" + "#{@requested_width_in_text}x#{@requested_height_in_text}" + "/" + "#{NAME_TO_FILENAME[@displayed_type]}"
  end
end