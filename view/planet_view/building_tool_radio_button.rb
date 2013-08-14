require 'gtk3'

require_relative '../common/building_image.rb'

class BuildingToolRadioButton < Gtk::RadioToolButton
  attr_reader :building_class
  
  def initialize(building_class)
	# Call super with no arguments.
	super()
	
	raise unless (building_class.is_a?(Class))
	@building_class = building_class
	
	building_instance = building_class.new
	
	self.icon_widget = BuildingImage.new(building_instance, [16, 16])
	self.label_widget = Gtk::Label.new("Add #{building_instance.name}")
	
	return self
  end
end