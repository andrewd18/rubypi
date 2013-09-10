require_relative 'planet_list_row.rb'

class PlanetList < Gtk::Box
  def initialize(controller)
	super(:vertical)
	
	@controller = controller
	
	self.show_all
	
	return self
  end
  
  def pi_configuration_model=(new_model)
	# TODO
	# The more planets there are, the longer this takes.
	# This also locks the entire app until it's done redrawing.
	# I should fix that.
	
	# Clean out rows.
	self.children.each do |child|
	  child.destroy
	end
	
	new_model.planets.each do |planet_model|
	  list_row = PlanetListRow.new(@controller, planet_model)
	  list_row_frame = Gtk::Frame.new
	  list_row_frame.add(list_row)
	  self.pack_start(list_row_frame, :expand => false)
	end
	
	self.show_all
	
	# Ask for a resize because stuff changed.
	self.queue_resize
  end
end