
require 'gtk3'

require_relative 'planet_view_widget.rb'
require_relative 'up_to_planet_view_button.rb'
require_relative 'edit_command_center_widget.rb'
require_relative 'edit_launchpad_widget.rb'
require_relative 'edit_storage_facility_widget.rb'
require_relative 'edit_extractor_widget.rb'
require_relative 'edit_factory_widget.rb'

# This is a layout-only widget that contains other, building-specific widgets.
class BuildingViewWidget < Gtk::Box
  
  attr_reader :building_widget
  
  def initialize(building_model)
	super(:vertical)
	
	# Hook up model data.
	@building_model = building_model
	
	# Create the top row.
	# Top row should contain a label stating what view we're looking at, followed by an UP button.
	top_row = Gtk::Box.new(:horizontal)
	
	building_view_label = Gtk::Label.new("Building View")
	
	# Add our up button.
	# TODO - Push this behavior out of this widget and into a "up to planet view button".
	#        "UpToPlanetViewButton.new" should be the only thing I call.
	@up_button = UpToPlanetViewButton.new(self)
	
	top_row.pack_start(building_view_label, :expand => true)
	top_row.pack_start(@up_button, :expand => false)
	self.pack_start(top_row, :expand => false)
	
	
	# Create the bottom row.
	# Bottom row should contain the specialized widget that lets you edit the building's model.
	bottom_row = Gtk::Box.new(:horizontal)
	
	if (@building_model.is_a? CommandCenter)
	  
	  # TODO
	  # Create an EditCommandCenterWidget.
	  @building_widget = EditCommandCenterWidget.new(@building_model)
	  
	  
	elsif (@building_model.is_a? Extractor)
	  
	  # TODO
	  # Create an EditExtractorWidget.
	  @building_widget = EditExtractorWidget.new(@building_model)
	  
	  
	elsif (@building_model.is_a? BasicIndustrialFacility or 
	       @building_model.is_a? AdvancedIndustrialFacility or
	       @building_model.is_a? HighTechIndustrialFacility)
	  
	  # Create an EditIndustrialFacilityWidget
	  @building_widget = EditFactoryWidget.new(@building_model)
	  
	  
	elsif (@building_model.is_a? Launchpad)
	  
	  # Create an EditIndustrialFacilityWidget
	  @building_widget = EditLaunchpadWidget.new(@building_model)
	  
	  
	elsif (@building_model.is_a? StorageFacility)
	  
	  # Create an EditIndustrialFacilityWidget
	  @building_widget = EditStorageFacilityWidget.new(@building_model)
	  
	  
	else
	  # Bitch and complain.
	  @building_widget = Gtk::Label.new("TODO: Error on unknown building model.")
	end
	
	
	bottom_row.pack_start(@building_widget, :expand => true)
	self.pack_start(bottom_row, :expand => true)
	
	return self
  end
  
  def building_model
	return @building_model
  end
  
  def building_model=(new_building_model)
	@building_model = new_building_model
	
	# Pass along to children.
	unless (@building_widget.is_a?(Gtk::Label))
	  @building_widget.building_model = @building_model
	end
  end
  
  def start_observing_model
	@building_model.add_observer(self)
	
	# Tell children to start observing.
	unless (@building_widget.is_a?(Gtk::Label))
	  @building_widget.start_observing_model
	end
  end
  
  def stop_observing_model
	@building_model.delete_observer(self)
	
	# Tell children to stop observing.
	unless (@building_widget.is_a?(Gtk::Label))
	  @building_widget.stop_observing_model
	end
  end
  
  # TODO: Ensure that each object commits as part of its destroy.
  # Going to involve some refactoring of the objects themselves.
  def commit_to_model
	# If I don't call this, the specific widget never saves its values.
	@building_widget.commit_to_model
  end
  
  def update
	# Do nothing.
  end
  
  def destroy
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end