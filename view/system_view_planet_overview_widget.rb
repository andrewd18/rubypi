
require 'gtk3'

# This widget is designed to show a single planet's image, its name, and its alias.
class SystemViewPlanetOverviewWidget < Gtk::Box
  def initialize(planet)
	super(:horizontal)
	
	# Hook up our model data.
	@planet = planet
	
	@planet.add_observer(self)
	
	builder = Gtk::Builder.new
	
	builder.add_from_file("view/system_view_planet_overview_widget.glade")
	
	@planet_image = builder.get_object('planet_image')
	@planet_name_label = builder.get_object('planet_name_label')
	@planet_alias_label = builder.get_object('planet_alias_label')
	@delete_planet_button = builder.get_object('delete_planet_button')
	
	update_image_name_and_alias
	
	vertical_layout = builder.get_object('vertical_layout')
	
	# Pack the completed widget into ourself.
	self.pack_start(vertical_layout)
	
	# Connect all the back-end signals.
	builder.connect_signals { |handler| self.method(handler) }
	
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
  end
  
  private
  
  # Update image, name, and alias values from the model.
  def update_image_name_and_alias
	# planet_image.image = planet.image
	@planet_name_label.text = @planet.name || ""
	@planet_alias_label.text = @planet.planet_alias || ""
  end
end