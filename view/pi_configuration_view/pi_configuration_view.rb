require 'gtk3'

require_relative 'planet_tool_palette.rb'
require_relative 'planet_list.rb'
require_relative 'save_to_yaml_dialog.rb'
require_relative 'load_from_yaml_dialog.rb'

class PIConfigurationView < Gtk::Box
  def initialize(controller)
	# Set up base GTK+ requirements.
	super(:horizontal)
	
	# Store the controller whose actions this view can use.
	@controller = controller
	
	# Set up all the widgets unique to this view. Delegate to subclasses where necessary.
	@planet_tool_palette = PlanetToolPalette.new(@controller)
	@planet_list = PlanetList.new(@controller)
	
	planet_list_scrolled_window = Gtk::ScrolledWindow.new
	planet_list_scrolled_window.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::AUTOMATIC)
	planet_list_scrolled_window.add(@planet_list)
	
	
	edit_selected_button = Gtk::Button.new(:stock_id => Gtk::Stock::EDIT)
	edit_selected_button.signal_connect("clicked") do |button|
	  @controller.edit_selected_planet(@planet_list.selected_planet_instance)
	end
	
	import_from_yaml_button = Gtk::Button.new(:stock_id => Gtk::Stock::OPEN)
	import_from_yaml_button.signal_connect("clicked") do |button|
	  self.load_from_yaml
	end
	
	export_to_yaml_button = Gtk::Button.new(:stock_id => Gtk::Stock::SAVE)
	export_to_yaml_button.signal_connect("clicked") do |button|
	  self.save_to_yaml
	end
	
	button_box = Gtk::Box.new(:vertical)
	button_box.pack_start(edit_selected_button, :expand => false)
	button_box.pack_start(import_from_yaml_button, :expand => false)
	button_box.pack_start(export_to_yaml_button, :expand => false)
	
	
	self.pack_start(@planet_tool_palette, :expand => false)
	self.pack_start(planet_list_scrolled_window, :expand => true)
	self.pack_start(button_box, :expand => false, :padding => 10)
	
	self.show_all
	
	return self
  end
  
  def save_to_yaml
	dialog = SaveToYamlDialog.new($ruby_pi_main_gtk_window)
	
	# Run the dialog.
	if dialog.run == Gtk::ResponseType::ACCEPT
	  # Get the filename the user gave us.
	  user_set_filename = dialog.filename
	  
	  # Append .yml to it, if necessary.
	  unless (user_set_filename.end_with?(".yml"))
		user_set_filename += ".yml"
	  end
	  
	  @controller.export_to_file(user_set_filename)
	end
	
	dialog.destroy
  end
  
  def load_from_yaml
	dialog = LoadFromYamlDialog.new($ruby_pi_main_gtk_window)
	
	# Run the dialog.
	if dialog.run == Gtk::ResponseType::ACCEPT
	  @controller.import_from_file(dialog.filename)
	end
	
	dialog.destroy
  end
  
  def pi_configuration_model=(new_model)
	# Update the view using the new model for values.
	@planet_list.pi_configuration_model = new_model
  end
end