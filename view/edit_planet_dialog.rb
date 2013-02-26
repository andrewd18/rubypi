require 'gtk3'
require_relative '../model/planet.rb'

class EditPlanetDialog < Gtk::Dialog
  def initialize(planet_model, parent_window = nil)
	# Gtk::Dialog#initialize(:title => nil, :parent => nil, :flags => 0, :buttons => nil
	super(:title => "Edit Planet",
	      :parent => parent_window,
	      :flags => (Gtk::Dialog::Flags::DESTROY_WITH_PARENT | Gtk::Dialog::Flags::MODAL)
	     )
	
	# add_button(Gtk::Stock id or "button text", Gtk::ResponseType)
	self.add_button(Gtk::Stock::CANCEL, :cancel)
	self.add_button(Gtk::Stock::OK, :ok)
	
	@planet_model = planet_model
	
	# Populate the combobox backend model.
	@list_store_of_planet_types = Gtk::ListStore.new(String)
	Planet::PLANET_TYPES.each_value do |value|
	  
	  # Skip "Uncolonized". I want them to hit Abandon rather than set type to Uncolonized.
	  unless (value == "Uncolonized")
		new_row = @list_store_of_planet_types.append
		new_row.set_value(0, value)
	  end
	end
	
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	edit_planet_table = Gtk::Table.new(3, 2)
	edit_planet_table.homogeneous = true
	
	# Planet Type Row
	planet_type_label = Gtk::Label.new("Planet Type:")
	@planet_type_combo_box = Gtk::ComboBox.new(:model => @list_store_of_planet_types)
	
	# Set up the view for the combo box column.
	combobox_renderer = Gtk::CellRendererText.new
	@planet_type_combo_box.pack_start(combobox_renderer, true)
	@planet_type_combo_box.add_attribute(combobox_renderer, "text", 0)
	
	# Set the current value's row active.
	value_array = Planet::PLANET_TYPES.values
	value_array.each_with_index do |value, index|
	  if (value == @planet_model.type)
		@planet_type_combo_box.active=(index)
	  end
	end
	
	# Attach everything.
	edit_planet_table.attach(planet_type_label, 0, 1, 0, 1)
	edit_planet_table.attach(@planet_type_combo_box, 1, 2, 0, 1)
	
	
	# Planet Name Row
	planet_name_label = Gtk::Label.new("Planet Name:")
	@planet_name_text_entry = Gtk::Entry.new
	if (@planet_model.name != nil)
	  @planet_name_text_entry.text = @planet_model.name
	end
	edit_planet_table.attach(planet_name_label, 0, 1, 1, 2)
	edit_planet_table.attach(@planet_name_text_entry, 1, 2, 1, 2)
	
	
	# Planet Alias Row
	planet_alias_label = Gtk::Label.new("Planet Alias:")
	@planet_alias_text_entry = Gtk::Entry.new
	if (@planet_model.alias != nil)
	  @planet_alias_text_entry.text = @planet_model.alias
	end
	edit_planet_table.attach(planet_alias_label, 0, 1, 2, 3)
	edit_planet_table.attach(@planet_alias_text_entry, 1, 2, 2, 3)
	
	# Connect up all the signals.
	self.signal_connect("response") do |dialog_box, response_id|
	  if (response_id == Gtk::ResponseType::OK)
		on_ok_response
	  end
	  
	  self.destroy
	end
	
	self.child.pack_start(edit_planet_table)
	self.show_all
	
	return self
  end
  
  def on_ok_response
	planet_type_value = @planet_type_combo_box.active_iter.get_value(0)
	
	@planet_model.type = planet_type_value
	@planet_model.name = @planet_name_text_entry.text
	@planet_model.alias = @planet_alias_text_entry.text
  end
end
