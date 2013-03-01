
require 'gtk3'
require_relative 'edit_planet_dialog.rb'
require_relative 'planet_image.rb'
require_relative 'building_count_table.rb'

# This widget will show a planet, its buildings, and building-related stats.

class PlanetStatsWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	# Hook up model data.
	@planet_model = planet_model
	@planet_model.add_observer(self)
	
	building_count_table = BuildingCountTable.new(@planet_model)
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	# Add planet building stats widgets in a nice grid.
	planet_stats_table = Gtk::Table.new(6, 2)
	
	# Planet Image Row
	@planet_image = PlanetImage.new(@planet_model)
	# Stick it in the top row, across all columns.
	planet_stats_table.attach(@planet_image, 0, 2, 0, 1)
	
	# Planet Label Row
	@planet_name_label = Gtk::Label.new("#{@planet_model.name}")
	# Stick it in the second row, across all columns.
	planet_stats_table.attach(@planet_name_label, 0, 2, 1, 2)
	
	# Planet Alias Row
	@planet_alias_label = Gtk::Label.new("#{@planet_model.alias}")
	# Stick it in the third row, across all columns.
	planet_stats_table.attach(@planet_alias_label, 0, 2, 2, 3)
	
	# Edit and Abandon Button Row
	@edit_button = Gtk::Button.new(:stock_id => Gtk::Stock::EDIT)
	@abandon_button = Gtk::Button.new(:label => "Abandon")
	
	@edit_button.signal_connect("pressed") do
	  edit_planet_dialog = EditPlanetDialog.new(@planet_model)
	  edit_planet_dialog.run
	end
	
	@abandon_button.signal_connect("pressed") do
	  # Abandon all colonies! q_q
	  @planet_model.abandon
	  
	  # Return to the system screen.
	  return_to_system_view
	end
	
	# Put the Edit button on the left and Abandon button on the right of the fourth row.
	planet_stats_table.attach(@edit_button, 0, 1, 3, 4)
	planet_stats_table.attach(@abandon_button, 1, 2, 3, 4)
	
	
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
	
	# TODO: ISK Cost Row.
	
	self.pack_start(building_count_table, :expand => false)
	self.pack_start(planet_stats_table, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  # The model data changed. Update the display.
	  @planet_name_label.text = @planet_model.name ||= ""
	  @planet_alias_label.text = @planet_model.alias ||= ""
	  
	  @cpu_used_pct_label.text = "#{@planet_model.cpu_usage} / #{@planet_model.cpu_provided}"
	  @pg_used_pct_label.text = "#{@planet_model.powergrid_usage} / #{@planet_model.powergrid_provided}"
	end
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	@planet_model.delete_observer(self)
	
	super
  end
  
  private
  
  def return_to_system_view
	$ruby_pi_main_gtk_window.change_main_widget(SystemViewWidget.new(@planet_model.pi_configuration))
  end
end