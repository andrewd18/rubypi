
require 'gtk3'
require_relative '../common/planet_image.rb'
require_relative 'building_count_table.rb'
require_relative 'isk_amount_label.rb'
require_relative '../../model/planet.rb'

require_relative '../gtk_helpers/simple_combo_box.rb'
require_relative '../gtk_helpers/simple_table.rb'

# This widget will show a planet, its buildings, and building-related stats.

class PlanetStatsWidget < Gtk::Box
  
  def initialize(controller)
	super(:vertical)
	
	@controller = controller
	
	# Create widgets.
	#
	# Standalone widgets.
	@building_count_table = BuildingCountTable.new
	@planet_image = PlanetImage.new
	
	
	# Widgets that will live in the planet_stats_table.
	#
	planet_type_label = Gtk::Label.new("Planet Type:")
	
	# Populate the planet type combo box with all the valid planet types.
	# TODO - Remove Uncolonized as an option. Going to require reworking some model tests.
	@planet_type_combo_box = SimpleComboBox.new(Planet::PLANET_TYPES_WITHOUT_UNCOLONIZED)
	@planet_type_combo_box.signal_connect("changed") do |combo_box|
	  @controller.change_planet_type(combo_box.selected_item)
	end
	
	planet_name_label = Gtk::Label.new("Name:")
	@planet_name_entry = Gtk::Entry.new
	@planet_name_entry.signal_connect("changed") do |text_entry|
	  @controller.change_planet_name(text_entry.text)
	end
	
	pg_used_label = Gtk::Label.new("PG Used:")
	@pg_used_progress_bar = Gtk::ProgressBar.new
	@pg_used_progress_bar.show_text = true  # WORKAROUND - If you don't force this to true, text is never shown.
	
	cpu_used_label = Gtk::Label.new("CPU Used:")
	@cpu_used_progress_bar = Gtk::ProgressBar.new
	@cpu_used_progress_bar.show_text = true # WORKAROUND - If you don't force this to true, text is never shown.
	
	isk_cost_label = Gtk::Label.new("ISK Cost:")
	@isk_cost_value_label = IskAmountLabel.new
	
	# Pack child widgets into planet_stats_table, one row at a time.
	rows = 5
	columns = 2
	planet_stats_table = SimpleTable.new(rows, columns)
	
	planet_stats_table.attach(planet_type_label, 1, 1)
	planet_stats_table.attach(@planet_type_combo_box, 1, 2)
	
	planet_stats_table.attach(planet_name_label, 2, 1)
	planet_stats_table.attach(@planet_name_entry, 2, 2)
	
	planet_stats_table.attach(pg_used_label, 3, 1)
	planet_stats_table.attach(@pg_used_progress_bar, 3, 2)
	
	planet_stats_table.attach(cpu_used_label, 4, 1)
	planet_stats_table.attach(@cpu_used_progress_bar, 4, 2)
	
	planet_stats_table.attach(isk_cost_label, 5, 1)
	planet_stats_table.attach(@isk_cost_value_label, 5, 2)
	
	
	
	# Pack widgets top to bottom.
	self.pack_start(@building_count_table, :expand => false)
	self.pack_start(@planet_image, :expand => false)
	self.pack_start(planet_stats_table, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def planet_model=(new_planet_model)
	@planet_model = new_planet_model
	
	# Pass along to children.
	@building_count_table.planet_model = new_planet_model
	@planet_image.planet_model = new_planet_model
	
	update_from_model
  end
  
  private
  
  def update_from_model
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  # Set the current combo box value.
	  @planet_type_combo_box.selected_item = @planet_model.type
	  
	  # Set the current planet name.
	  @planet_name_entry.text = @planet_model.name
	  
	  # Set the CPU used and PG used values.
	  @cpu_used_progress_bar.text = "#{@planet_model.pct_cpu_usage.round(2)} %"
	  
	  if (@planet_model.pct_cpu_usage > 100)
		@cpu_used_progress_bar.fraction = 1.0
	  else
		@cpu_used_progress_bar.fraction = (@planet_model.pct_cpu_usage / 100.0)
	  end
	  
	  
	  @pg_used_progress_bar.text = "#{@planet_model.pct_powergrid_usage.round(2)} %"
	  
	  if (@planet_model.pct_powergrid_usage > 100)
		@pg_used_progress_bar.fraction = 1.0
	  else
		@pg_used_progress_bar.fraction = (@planet_model.pct_powergrid_usage / 100.0)
	  end
	  
	  # Set the isk cost.
	  @isk_cost_value_label.isk_value = @planet_model.isk_cost
	end
  end
end