require 'gtk3'

class BuildingToolRadioButton < Gtk::RadioToolButton
  attr_reader :building_class
  
  def initialize(building_class)
	# Call super with no arguments.
	super()
	
	raise unless (building_class.is_a?(Class))
	@building_class = building_class
	
	building_instance = building_class.new
	
	pixbuf = CairoBuildingImage.new(building_instance, 32, 32).image
	self.icon_widget = Gtk::Image.new(:pixbuf => pixbuf)
	self.label_widget = Gtk::Label.new("Add #{building_instance.name}")
	
	return self
  end
end