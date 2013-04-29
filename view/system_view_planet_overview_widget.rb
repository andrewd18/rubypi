
require 'gtk3'

require_relative 'planet_view_widget.rb'
require_relative 'planet_image.rb'
require_relative 'building_count_table.rb'

# TODO: This widget is really similar to the Planetary Stats Widget. I should clean that up.

# This widget is designed to show a single planet's image, its name, and its alias.
class SystemViewPlanetOverviewWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	# Hook up our model data.
	@planet_model = planet_model
	
	@building_count_table = BuildingCountTable.new(@planet_model)
	
	
	# Planet image and event wrapper for double-click events.
	@planet_image_event_wrapper = Gtk::EventBox.new
	@planet_image_event_wrapper.events = Gdk::Event::Mask::BUTTON_PRESS_MASK
	
	@planet_image = PlanetImage.new(@planet_model)
	@planet_image_event_wrapper.add(@planet_image)
	
	@planet_name_label = Gtk::Label.new("#{@planet_model.name}")
	@planet_alias_label = Gtk::Label.new("#{@planet_model.alias}")
	@edit_planet_button = Gtk::Button.new(:stock_id => Gtk::Stock::EDIT)
	
	# Pack the completed widget into ourself.
	self.pack_start(@building_count_table, :expand => false)
	self.pack_start(@planet_image_event_wrapper, :expand => false)
	self.pack_start(@planet_name_label, :expand => false)
	self.pack_start(@planet_alias_label, :expand => false)
	
	self.pack_start(@edit_planet_button, :expand => false)
	@edit_planet_button.signal_connect("clicked") do
	  # Open up the edit planet screen.
	  edit_planet
	end
	
	# Connect the backend signals.
	
	@planet_image_event_wrapper.signal_connect("button_press_event") do |main_window, event|
	  on_planet_image_button_press_event(event)
	end
	
	# Show child widgets.
	self.show_all
	
	return self
  end
  
  def on_planet_image_button_press_event(event)
	# If it's a double-click, open up the edit planet screen.
	if (event.event_type == Gdk::Event::Type::BUTTON2_PRESS)
	  edit_planet
	end
  end
  
  def planet_model
	return @planet_model
  end
  
  def planet_model=(new_planet_model)
	@planet_model = new_planet_model
	
	# Pass along to the children.
	@planet_image.planet_model = (@planet_model)
	@building_count_table.planet_model = (@planet_model)
  end
  
  def start_observing_model
	@planet_model.add_observer(self)
	
	# Pass along to the children.
	@planet_image.start_observing_model
	@building_count_table.start_observing_model
  end
  
  def stop_observing_model
	@planet_model.delete_observer(self)
	
	# Pass along to the children.
	@planet_image.stop_observing_model
	@building_count_table.stop_observing_model
  end
  
  # Called when our planet says it's changed.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @planet_name_label.text = @planet_model.name || ""
	  @planet_alias_label.text = @planet_model.alias || ""
	end
  end
  
  def edit_planet
	$ruby_pi_main_gtk_window.change_main_widget(PlanetViewWidget.new(@planet_model))
  end
  
  def destroy
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end