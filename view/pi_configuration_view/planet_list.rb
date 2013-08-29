require_relative 'planet_list_row.rb'

class PlanetList < Gtk::Box
  def initialize(controller)
	super(:vertical)
	
	@controller = controller
	
	self.show_all
	
	return self
  end
  
  def pi_configuration_model=(new_model)
	# Clean out rows.
	self.children.each do |child|
	  child.destroy
	end
	
	new_model.planets.each do |planet_model|
	  self.pack_start(PlanetListRow.new(@controller, planet_model), :expand => false)
	end
	
	self.show_all
  end
end