
require 'gtk3'

require_relative 'planet_view_widget.rb'
require_relative 'colonize_planet_dialog.rb'

# This widget is designed to show a single planet's image, its name, and its alias.
class SystemViewPlanetOverviewWidget < Gtk::Box
  def initialize(planet)
	super(:vertical)
	
	# Hook up our model data.
	@planet_model = planet
	@planet_model.add_observer(self)
	
	@planet_image_event_wrapper = Gtk::EventBox.new
	@planet_image_event_wrapper.events = Gdk::Event::Mask::BUTTON_PRESS_MASK
	
	# TODO: Chage planet image based on type.
	@planet_image = Gtk::Image.new("view/images/extractor_icon.svg")
	@planet_image_event_wrapper.add(@planet_image)
	
	if (@planet_model.type == "Uncolonized")
	  @planet_name_label = Gtk::Label.new("Uncolonized")
	  @planet_alias_label = Gtk::Label.new("")
	  @colonize_planet_button = Gtk::Button.new(:label => "Colonize")
	else
	  @planet_name_label = Gtk::Label.new("#{@planet_model.name}" || "")
	  @planet_alias_label = Gtk::Label.new("#{@planet_model.alias}" || "")
	  @edit_planet_button = Gtk::Button.new(:stock_id => Gtk::Stock::EDIT)
	end
	
	# Pack the completed widget into ourself.
	self.pack_start(@planet_image_event_wrapper)
	self.pack_start(@planet_name_label)
	self.pack_start(@planet_alias_label)
	
	if (@edit_planet_button)
	  self.pack_start(@edit_planet_button)
	  @edit_planet_button.signal_connect("clicked") do
		# Open up the edit planet screen.
		edit_planet
	  end
	end
	
	if (@colonize_planet_button)
	  self.pack_start(@colonize_planet_button)
	  @colonize_planet_button.signal_connect("clicked") do
		# Open up the colonize planet dialog.
		colonize_planet
	  end
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
  
  # Called when our planet says it's changed.
  def update
	update_image_name_and_alias
  end
  
  def edit_planet
	new_window = Gtk::Window.new(:toplevel)
	new_window.add(PlanetViewWidget.new(@planet_model))
	new_window.show_all
  end
  
  def colonize_planet
	colonize_planet_dialog = ColonizePlanetDialog.new(@planet_model)
	colonize_planet_dialog.run
	
	# Assuming the user colonized the planet rather than canceling, edit the planet we just colonized.
	if (@planet_model.type != "Uncolonized")
	  edit_planet
	end
  end
  
  private
  
  # Update image, name, and alias values from the model.
  def update_image_name_and_alias
	# planet_image.image = planet.image
	@planet_name_label.text = @planet_model.name || ""
	@planet_alias_label.text = @planet_model.alias || ""
  end
end