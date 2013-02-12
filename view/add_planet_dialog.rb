require 'gtk3'
require_relative '../model/planet.rb'

class AddPlanetDialog
  def initialize(parent_system_view, pi_configuration_model)
	@parent_system_view = parent_system_view
	@pi_configuration_model = pi_configuration_model
	
	builder = Gtk::Builder.new

	builder.add_from_file("view/add_planet_dialog.glade")

	@dialog = builder.get_object('add_planet_dialog')
	
	# Populate the combobox backend model.
	@list_store_of_planet_types = Gtk::ListStore.new(String)
	Planet::PLANET_TYPES.each_value do |value|
	  new_row = @list_store_of_planet_types.append
	  new_row.set_value(0, value)
	end
	
	@planet_type_combo_box = builder.get_object('planet_type_combo_box')
	
	# Set up the model.
	@planet_type_combo_box.model=(@list_store_of_planet_types)
	
	# Set up the view for the combo box column.
	combobox_renderer = Gtk::CellRendererText.new
	@planet_type_combo_box.pack_start(combobox_renderer, true)
	@planet_type_combo_box.add_attribute(combobox_renderer, "text", 0)
	
	
	@name_field = builder.get_object('planet_name_text_entry')
	@alias_field = builder.get_object('planet_alias_text_entry')
	
	builder.connect_signals { |handler| self.method(handler) }
	
	return self
  end
  
  def run
	@dialog.run do |response|
	  case response
		when (Gtk::ResponseType::OK)
		  planet_type_value = @planet_type_combo_box.active_iter.get_value(0)
		  
		  new_planet = Planet.new(planet_type_value, @name_field.text, @alias_field.text)
		  
		  # Then, once we've done whatever the user wants, destroy ourselves.
		  @dialog.destroy
		  
		  return new_planet
		else
		  puts "AddPlanetDialog.run: Do nothing because we cancelled."
		  
		  # Then, once we've done whatever the user wants, destroy ourselves.
		  @dialog.destroy
		end
	end
  end
end
