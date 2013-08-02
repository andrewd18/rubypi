require_relative 'add_planets_list_store.rb'

require_relative 'icon_column.rb'
require_relative 'text_column.rb'


class AddPlanetsTreeView < Gtk::TreeView
  def initialize(pi_configuration_model)
	@pi_configuration_model = pi_configuration_model
	
	@list_model = AddPlanetsListStore.new
	super(@list_model)
	
	# Create columns for the tree view.
	icon_column = IconColumn.new("Icon", 0)
	name_column = TextColumn.new("Name", 1)
	
	# Pack columns in tree view, left-to-right.
	self.append_column(icon_column)
	self.append_column(name_column)
	
	
	# Signals
	# On double-click, run the add_product_dialog method.
	self.signal_connect("row-activated") do |tree_view, path, column|
	  self.add_planet
	end
	
	return self
  end
  
  def add_planet
	# Get a tree iter to the selected row.
	row = self.selection
	tree_iter = row.selected
	
	selected_planet_type = tree_iter.get_value(1)
	
	# Check for errors.
	# Make sure the selected planet type is an actual planet type.
	if (Planet::PLANET_TYPES.include?(selected_planet_type) == false)
	  puts "User tried to add a planet type that is not defined in Planet::PLANET_TYPES."
	  return nil
	end
	
	new_planet = Planet.new(selected_planet_type)
	new_planet.add_customs_office
	@pi_configuration_model.add_planet(new_planet)
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end