
require 'gtk3'

# This widget is designed to show a single planet's image, its name, and its alias.
class SystemViewPlanetOverviewWidget < Gtk::Box
  def initialize(planet)
	super(:vertical)
	
	# Hook up our model data.
	@planet_model = planet
	@planet_model.add_observer(self)
	
	@planet_image_event_wrapper = Gtk::EventBox.new
	@planet_image_event_wrapper.events = Gdk::Event::BUTTON_PRESS_MASK
	
	@planet_image = Gtk::Image.new("view/images/extractor_icon.svg")
	@planet_image_event_wrapper.add(@planet_image)
	
	@planet_name_label = Gtk::Label.new("#{@planet_model.name}" || "")
	@planet_alias_label = Gtk::Label.new("#{@planet_model.planet_alias}" || "")
	@delete_planet_button = Gtk::Button.new(:stock_id => Gtk::Stock::DELETE)
	
	# Pack the completed widget into ourself.
	self.pack_start(@planet_image_event_wrapper)
	self.pack_start(@planet_name_label)
	self.pack_start(@planet_alias_label)
	self.pack_start(@delete_planet_button)
	
	# Connect the backend signals.
	@delete_planet_button.signal_connect("clicked") do
	  on_delete_planet_button_clicked
	end
	
	@planet_image_event_wrapper.signal_connect("button_press_event") do |main_window, event|
	  on_planet_image_button_press_event(event)
	end
	
	# Show child widgets.
	self.show_all
	
	return self
  end
  
  # Called when our planet says it's changed.
  def update
	update_image_name_and_alias
  end
  
  def on_delete_planet_button_clicked
	@planet.remove_planet
	self.destroy
  end
  
  def on_planet_image_button_press_event(event)
	puts "on_planet_image_button_press_event"
	
	if event.event_type == Gdk::Event::BUTTON2_PRESS
	  puts "Double-click!"
	else
	  puts "Not double-click."
	end
  end
  
  private
  
  # Update image, name, and alias values from the model.
  def update_image_name_and_alias
	# planet_image.image = planet.image
	@planet_name_label.text = @planet_model.name || ""
	@planet_alias_label.text = @planet_model.planet_alias || ""
  end
end