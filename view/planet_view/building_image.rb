require 'gtk3'

# Creates an image of a building based off of its model type.

class BuildingImage < Gtk::Image
  
  BASE_IMAGES_FOLDER = "view/images"
  
  NAME_TO_FILENAME = { "Command Center" => "command_center_icon.png",
                       "Extractor" => "extractor_icon.png",
                       "Storage Facility" => "storage_facility_icon.png",
                       "Launchpad" => "launchpad_icon.png",
                       "Basic Industrial Facility" => "industrial_facility_two_materials.png",
                       "Advanced Industrial Facility" => "industrial_facility_two_materials.png",
                       "High Tech Industrial Facility" => "industrial_facility_three_materials.png",
                       "Extractor Head" => "extractor_head_icon.png",
                       "Customs Office" => "poco_icon.png"}
  
  def initialize(building_model, requested_size_array_in_px = [64, 64])
	raise ArgumentError unless (NAME_TO_FILENAME.include?(building_model.name))
	@building_model = building_model
	
	@requested_width = requested_size_array_in_px[0]
	@requested_height = requested_size_array_in_px[1]
	
	super(:file => calculate_filename)
	
	self.set_size_request(@requested_width, @requested_height)
	
	return self
  end
  
  # Called when the @building_model changes.
  def building_model=(new_building_model)
	raise ArgumentError unless (NAME_TO_FILENAME.include?(@building_model.name))
	@building_model = new_building_model
	
	# Recalculate filename.
	self.file = calculate_filename
  end
  
  private
  
  def calculate_filename
	return "#{BASE_IMAGES_FOLDER}" + "/" + "#{@requested_width}x#{@requested_height}" + "/" + "#{NAME_TO_FILENAME[@building_model.name]}"
  end
end