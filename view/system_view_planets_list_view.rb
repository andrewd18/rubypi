require_relative 'icon_column.rb'
require_relative 'text_column.rb'
require_relative 'system_view_planets_store.rb'

class SystemViewPlanetsListView < Gtk::TreeView
  def initialize(pi_configuration_model)
	@pi_configuration_model = pi_configuration_model
	
	@system_view_planets_store = SystemViewPlanetsStore.new(@pi_configuration_model)
	
	super(@system_view_planets_store)
	
	# Create columns for the tree view.
	icon_column = IconColumn.new("Icon", 2)
	name_column = TextColumn.new("Name", 3)
	num_extractors_column = TextColumn.new("Extractors", 4)
	num_factories_column = TextColumn.new("Factories", 5)
	num_storages_column = TextColumn.new("Storages", 6)
	num_launchpads_column = TextColumn.new("Launchpads", 7)
	
	# Pack columns in tree view, left-to-right.
	self.append_column(icon_column)
	self.append_column(name_column)
	self.append_column(num_extractors_column)
	self.append_column(num_factories_column)
	self.append_column(num_storages_column)
	self.append_column(num_launchpads_column)
	
	# Signals
	# On double-click, run the remove_product_dialog method.
	self.signal_connect("row-activated") do |tree_view, path, column|
	  self.remove_planet
	end
	
	# Tree View settings.
	self.reorderable = true
	
	return self
  end
  
  def pi_configuration_model=(new_pi_configuration_model)
	# Pass new model along to store.
	@system_view_planets_store.pi_configuration_model=(new_pi_configuration_model)
  end
  
  def remove_planet
	# Get a tree iter to the selected row.
	row = self.selection
	tree_iter = row.selected
	
	selected_planet_instance = tree_iter.get_value(1)
	
	@pi_configuration_model.remove_planet(selected_planet_instance)
  end
  
  def start_observing_model
	@system_view_planets_store.start_observing_model
  end
  
  def stop_observing_model
	@system_view_planets_store.stop_observing_model
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	# Clean this up manually.
	@system_view_planets_store.destroy
	
	super
  end
end