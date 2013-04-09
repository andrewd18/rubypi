
require 'gtk3'

require_relative 'planet_view_widget.rb'
require_relative 'factory_edit_widget.rb'

class BuildingViewWidget < Gtk::Box
  def initialize(building_model)
	super(:vertical)
	
	# Hook up model data.
	@building_model = building_model
	
	# Create the top row.
	top_row = Gtk::Box.new(:horizontal)
	
	building_view_label = Gtk::Label.new("Building View")
	
	# Add our up button.
	@up_button = Gtk::Button.new(:stock_id => Gtk::Stock::GO_UP)
	@up_button.signal_connect("pressed") do
	  return_to_planet_view
	end
	
	top_row.pack_start(building_view_label, :expand => true)
	top_row.pack_start(@up_button, :expand => false)
	self.pack_start(top_row, :expand => false)
	
	# Create the bottom row.
	bottom_row = Gtk::Box.new(:horizontal)
	
	if (@building_model.is_a? CommandCenter)
	  
	  # Stuff
	  
	elsif (@building_model.is_a? Extractor)
	  
	  # Stuff
	  
	elsif (@building_model.is_a? BasicIndustrialFacility or 
	       @building_model.is_a? AdvancedIndustrialFacility or
	       @building_model.is_a? HighTechIndustrialFacility)
	  
	  # Stuff
	  @building_widget = FactoryEditWidget.new(@building_model)
	  
	else
	  
	  # Stuff
	  
	end
	
	bottom_row.pack_start(@building_widget, :expand => false)
	self.pack_start(bottom_row, :expand => true)
	
	return self
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
  
  private
  
  def return_to_planet_view
	# Before we return, save the data to the model.
	# TODO
	@building_widget.commit_to_model
	
	$ruby_pi_main_gtk_window.change_main_widget(PlanetViewWidget.new(@building_model.planet))
  end
end