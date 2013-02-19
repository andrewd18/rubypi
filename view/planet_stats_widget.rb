
require 'gtk3'

# This widget will show a planet, its buildings, and building-related stats.

class PlanetStatsWidget < Gtk::Box
  def initialize(planet_model)
	super(:vertical)
	
	# Hook up model data.
	@planet_model = planet_model
	@planet_model.add_observer(self)
	
	# Add planet info widgets.
	@planet_image = Gtk::Image.new(:file => "view/images/extractor_icon.svg")
	@planet_name_label = Gtk::Label.new("#{@planet_model.name}")
	@planet_alias_label = Gtk::Label.new("#{@planet_model.alias}")
	
	# Add planet building stats widgets, in a nice grid below the planet itself.
	#
	# HACK: Since Gtk::Grid is undocumented, fake a grid using boxes.
	# For each row, assemble a box containing that row's data and pack_start it to the row_holder.
	row_holder = Gtk::Box.new(:vertical)
	
	# Row 1 - CPU status.
	row_one = Gtk::Box.new(:horizontal)
	cpu_label = Gtk::Label.new("CPU:")
	@cpu_used_pct_label = Gtk::Label.new("#{@planet_model.cpu_usage} / #{@planet_model.cpu_provided}")
	# cpu_used_pct_progress_bar = Gtk::Label.new("0 / 0")
	row_one.pack_start(cpu_label)
	row_one.pack_start(@cpu_used_pct_label)
	row_holder.pack_start(row_one)
	
	# Row 2 - Powergrid status.
	row_two = Gtk::Box.new(:horizontal)
	pg_label = Gtk::Label.new("PG:")
	@pg_used_pct_label = Gtk::Label.new("#{@planet_model.powergrid_usage} / #{@planet_model.powergrid_provided}")
	# cpu_used_pct_progress_bar = Gtk::Label.new("0 / 0")
	row_two.pack_start(pg_label)
	row_two.pack_start(@pg_used_pct_label)
	row_holder.pack_start(row_two)
	
	# Row 3 - ISK status.
	#row_three = Gtk::Box(:horizontal)
	#row_holder.pack_start(row_three)
	
	self.pack_start(@planet_image)
	self.pack_start(@planet_name_label)
	self.pack_start(@planet_alias_label)
	self.pack_start(row_holder)
	
	self.show_all
	
	# Force a refresh.
	# update
	
	return self
  end
  
  def update
	# The model data changed. Update the display.
	# @planet_image = Image.new
	@planet_name_label.text = @planet_model.name
	@planet_alias_label.text = @planet_model.alias
	
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
end