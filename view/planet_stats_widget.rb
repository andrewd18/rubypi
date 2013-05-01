
require 'gtk3'
require_relative 'planet_image.rb'
require_relative 'building_count_table.rb'
require_relative '../model/planet.rb'

# This widget will show a planet, its buildings, and building-related stats.

class PlanetStatsWidget < Gtk::Box
  
  attr_accessor :planet_type_combo_box
  
  def initialize(planet_model)
	super(:vertical)
	
	# Hook up model data.
	@planet_model = planet_model
	
	@building_count_table = BuildingCountTable.new(@planet_model)
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	# Add planet building stats widgets in a nice grid.
	planet_stats_table = Gtk::Table.new(7, 2)
	
	# Planet Image Row
	@planet_image = PlanetImage.new(@planet_model)
	# Stick it in the top row, across all columns.
	planet_stats_table.attach(@planet_image, 0, 2, 0, 1)
	
	# Planet Type Row
	planet_type_label = Gtk::Label.new("Planet Type:")
	
	
	
	# Populate the combo box with the schematics this factory can accept.
	@planet_type_combo_box = Gtk::ComboBoxText.new
	Planet::PLANET_TYPES.each do |type|
	  @planet_type_combo_box.append_text(type)
	end
	
	# Set up immediate commit on change.
	@planet_type_combo_box.signal_connect("changed") do
	  self.commit_to_model
	end
	
	
	planet_stats_table.attach(planet_type_label, 0, 1, 1, 2)
	planet_stats_table.attach(@planet_type_combo_box, 1, 2, 1, 2)
	
	
	# Planet Label Row
	planet_name_label = Gtk::Label.new("Name:")
	planet_stats_table.attach(planet_name_label, 0, 1, 2, 3)
	
	@planet_name_entry = Gtk::Entry.new
	@planet_name_entry.text = "#{@planet_model.name}"
	# Stick it in the second row, in second column.
	planet_stats_table.attach(@planet_name_entry, 1, 2, 2, 3)
	
	# Planet Alias Row
	planet_alias_label = Gtk::Label.new("Alias:")
	planet_stats_table.attach(planet_alias_label, 0, 1, 3, 4)
	
	@planet_alias_entry = Gtk::Entry.new
	@planet_alias_entry.text = "#{@planet_model.alias}"
	# Stick it in the third row, across all columns.
	planet_stats_table.attach(@planet_alias_entry, 1, 2, 3, 4)
	
	# CPU Row.
	cpu_label = Gtk::Label.new("CPU:")
	@cpu_used_pct_label = Gtk::Label.new("#{@planet_model.cpu_usage} / #{@planet_model.cpu_provided}")
	# Put the label on the left and and the stats on the right of the fifth row.
	planet_stats_table.attach(cpu_label, 0, 1, 4, 5)
	planet_stats_table.attach(@cpu_used_pct_label, 1, 2, 4, 5)
	
	
	# Powergrid Row.
	pg_label = Gtk::Label.new("PG:")
	@pg_used_pct_label = Gtk::Label.new("#{@planet_model.powergrid_usage} / #{@planet_model.powergrid_provided}")
	# Put the label on the left and and the stats on the right of the sixth row.
	planet_stats_table.attach(pg_label, 0, 1, 5, 6)
	planet_stats_table.attach(@pg_used_pct_label, 1, 2, 5, 6)
	
	# ISK Cost Row.
	isk_label = Gtk::Label.new("ISK Cost:")
	@isk_cost_label = Gtk::Label.new("#{@planet_model.isk_cost}")
	# Put the main label on the left and the cost on the right of the seventh row.
	planet_stats_table.attach(isk_label, 0, 1, 6, 7)
	planet_stats_table.attach(@isk_cost_label, 1, 2, 6, 7)
	
	self.pack_start(@building_count_table, :expand => false)
	self.pack_start(planet_stats_table, :expand => false)
	
	# Finally, update all the values.
	# Since #update does this, call #update.
	self.update
	
	self.show_all
	
	return self
  end
  
  def planet_model
	return @planet_model
  end
  
  def planet_model=(new_planet_model)
	@planet_model = new_planet_model
	
	# Pass along to children.
	@building_count_table.planet_model = new_planet_model
	@planet_image.planet_model = new_planet_model
  end
  
  def start_observing_model
	@planet_model.add_observer(self)
	
	# Inform children.
	@building_count_table.start_observing_model
	@planet_image.start_observing_model
  end
  
  def stop_observing_model
	@planet_model.delete_observer(self)
	
	# Inform children.
	@building_count_table.stop_observing_model
	@planet_image.stop_observing_model
  end
  
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  # The model data changed. Update the display.
	  
	  # TODO - Make this not rely on having PLANET_TYPES iter match the combo box iter.
	  # Set the current value's row active.
	  value_array = Planet::PLANET_TYPES
	  value_array.each_with_index do |value, index|
		if (value == @planet_model.type)
		  @planet_type_combo_box.active=(index)
		end
	  end
	  
	  @planet_name_entry.text = @planet_model.name ||= ""
	  @planet_alias_entry.text = @planet_model.alias ||= ""
	  
	  @cpu_used_pct_label.text = "#{@planet_model.cpu_usage} / #{@planet_model.cpu_provided}"
	  @pg_used_pct_label.text = "#{@planet_model.powergrid_usage} / #{@planet_model.powergrid_provided}"
	  
	  @isk_cost_label.text = "#{@planet_model.isk_cost}"
	end
  end
  
  def commit_to_model
	# Stop observing so the values we want to set don't get overwritten on an #update.
	self.stop_observing_model
	
	planet_type_value = @planet_type_combo_box.active_iter.get_value(0)
	
	if (planet_type_value == "Uncolonized")
	  @planet_model.abandon
	  
	  # Force an #update because we know the values have changed, and we didn't change them.
	  self.update
	else
	  @planet_model.type = planet_type_value
	  @planet_model.alias = @planet_alias_entry.text
	  @planet_model.name = @planet_name_entry.text
	end
	
	# Start observing again.
	self.start_observing_model
  end
  
  def destroy
	self.commit_to_model
	
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
  
  private
  
  def return_to_system_view
	$ruby_pi_main_gtk_window.change_main_widget(SystemViewWidget.new(@planet_model.pi_configuration))
  end
end