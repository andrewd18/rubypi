
require 'gtk3'
require_relative 'edit_planet_dialog.rb'

# This widget will show a planet, its buildings, and building-related stats.

class PlanetStatsWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	# Hook up model data.
	@planet_model = planet_model
	@planet_model.add_observer(self)
	
	
	# Add our up button.
	@up_button = Gtk::Button.new(:stock_id => Gtk::Stock::GO_UP)
	@up_button.signal_connect("pressed") do
	  return_to_system_view
	end
	self.pack_start(@up_button)
	
	
	# Add planet info widgets.
	@planet_image = Gtk::Image.new(:file => "view/images/extractor_icon.svg")
	@planet_name_label = Gtk::Label.new("#{@planet_model.name}")
	@planet_alias_label = Gtk::Label.new("#{@planet_model.alias}")
	
	# Add planet building stats widgets, in a nice grid below the planet itself.
	#
	# HACK: Since Gtk::Grid is undocumented, fake a grid using boxes.
	# For each row, assemble a box containing that row's data and pack_start it to the row_holder.
	row_holder = Gtk::Box.new(:vertical)
	
	
	# Edit / Abandon Planet Row
	edit_planet_row = Gtk::Box.new(:horizontal)
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
	
	edit_planet_row.pack_start(@edit_button)
	edit_planet_row.pack_start(@abandon_button)
	row_holder.pack_start(edit_planet_row)
	
	
	# CPU Row.
	cpu_row = Gtk::Box.new(:horizontal)
	cpu_label = Gtk::Label.new("CPU:")
	@cpu_used_pct_label = Gtk::Label.new("#{@planet_model.cpu_usage} / #{@planet_model.cpu_provided}")
	# cpu_used_pct_progress_bar = Gtk::Label.new("0 / 0")
	cpu_row.pack_start(cpu_label)
	cpu_row.pack_start(@cpu_used_pct_label)
	row_holder.pack_start(cpu_row)
	
	# Powergrid Row.
	pg_row = Gtk::Box.new(:horizontal)
	pg_label = Gtk::Label.new("PG:")
	@pg_used_pct_label = Gtk::Label.new("#{@planet_model.powergrid_usage} / #{@planet_model.powergrid_provided}")
	# cpu_used_pct_progress_bar = Gtk::Label.new("0 / 0")
	pg_row.pack_start(pg_label)
	pg_row.pack_start(@pg_used_pct_label)
	row_holder.pack_start(pg_row)
	
	# TODO: ISK Cost Row.
	
	# Pack all the pieces together.
	self.pack_start(@planet_image)
	self.pack_start(@planet_name_label)
	self.pack_start(@planet_alias_label)
	self.pack_start(row_holder)
	
	self.show_all
	
	return self
  end
  
  def update
	# The model data changed. Update the display.
	# @planet_image = Image.new
	@planet_name_label.text = @planet_model.name ||= ""
	@planet_alias_label.text = @planet_model.alias ||= ""
	
	@cpu_used_pct_label.text = "#{@planet_model.cpu_usage} / #{@planet_model.cpu_provided}"
	@pg_used_pct_label.text = "#{@planet_model.powergrid_usage} / #{@planet_model.powergrid_provided}"
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