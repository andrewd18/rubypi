require 'gtk3'
require_relative '../model/planet.rb'

# TODO: This class is really similar (aka I copied and pasted it) to ColonizePlanetDialog.
# I should attempt to merge the two.

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
	  new_row = @list_store_of_planet_types.append
	  new_row.set_value(0, value)
	end
	
	
	
	# HACK: Since Gtk::Grid is undocumented, fake a grid using boxes.
	# For each row, assemble a box containing that row's data and pack_start it to the row_holder.
	row_holder = Gtk::Box.new(:vertical)
	
	# Row 1 - Planet Type.
	row_one = Gtk::Box.new(:horizontal)
	planet_type_label = Gtk::Label.new("Planet Type:")
	
	# Combo box.
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
	
	# Finish packing Row 1.
	row_one.pack_start(planet_type_label)
	row_one.pack_start(@planet_type_combo_box)
	row_holder.pack_start(row_one)
	
	# Row 2 - Planet Name.
	row_two = Gtk::Box.new(:horizontal)
	planet_name_label = Gtk::Label.new("Planet Name:")
	@planet_name_text_entry = Gtk::Entry.new
	# Load from model.
	@planet_name_text_entry.text = @planet_model.name
	row_two.pack_start(planet_name_label)
	row_two.pack_start(@planet_name_text_entry)
	row_holder.pack_start(row_two)
	
	# Row 3 - Planet Alias.
	row_three = Gtk::Box.new(:horizontal)
	planet_alias_label = Gtk::Label.new("Planet Alias:")
	@planet_alias_text_entry = Gtk::Entry.new
	@planet_alias_text_entry.text = @planet_model.alias
	row_three.pack_start(planet_alias_label)
	row_three.pack_start(@planet_alias_text_entry)
	row_holder.pack_start(row_three)
	
	# Connect up all the signals.
	self.signal_connect("response") do |dialog_box, response_id|
	  if (response_id == Gtk::ResponseType::OK)
		on_ok_response
	  end
	  
	  self.destroy
	end
	
	self.child.pack_start(row_holder)
	self.show_all
	
	return self
  end
  
  def on_ok_response
	planet_type_value = @planet_type_combo_box.active_iter.get_value(0)
	
	if (planet_type_value != "Uncolonized")
	  @planet_model.type = planet_type_value
	  @planet_model.name = @planet_name_text_entry.text
	  @planet_model.alias = @planet_alias_text_entry.text
	end
  end
end
