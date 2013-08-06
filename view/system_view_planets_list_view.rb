require_relative 'system_view_planets_store.rb'

require_relative 'gtk_helpers/icon_column.rb'
require_relative 'gtk_helpers/text_column.rb'
require_relative 'gtk_helpers/text_column_with_image_header.rb'
require_relative 'gtk_helpers/progress_bar_column.rb'

class SystemViewPlanetsListView < Gtk::TreeView
  def initialize(pi_configuration_model)
	@pi_configuration_model = pi_configuration_model
	
	@system_view_planets_store = SystemViewPlanetsStore.new(@pi_configuration_model)
	
	super(@system_view_planets_store)
	
	# Create columns for the tree view.
	icon_column = IconColumn.new("", 2)
	name_column = TextColumn.new("Name", 3)
	pct_powergrid_usage_column = ProgressBarColumn.new("PG Usage", 4, 5)  # Header, Actual Value, Pct to Fill Bar
	pct_cpu_usage_column = ProgressBarColumn.new("CPU Usage", 6, 7)  # Header, Actual Value, Pct to Fill Bar
	num_extractors_column = TextColumnWithImageHeader.new("view/images/minimalistic_extractor_icon.png", 8)
	num_factories_column = TextColumnWithImageHeader.new("view/images/minimalistic_factory_icon.png", 9)
	num_storages_column = TextColumnWithImageHeader.new("view/images/minimalistic_storage_facility_icon.png", 10)
	num_launchpads_column = TextColumnWithImageHeader.new("view/images/minimalistic_launchpad_icon.png", 11)
	
	# Set a default width for the icon column. 36 pixels should be enough for anyone.
	icon_column.min_width = 36
	
	# Allow the name column to expand before the others do.
	name_column.expand = true
	
	# Pack columns in tree view, left-to-right.
	self.append_column(icon_column)
	self.append_column(name_column)
	self.append_column(pct_powergrid_usage_column)
	self.append_column(pct_cpu_usage_column)
	self.append_column(num_extractors_column)
	self.append_column(num_factories_column)
	self.append_column(num_storages_column)
	self.append_column(num_launchpads_column)
	
	# Signals
	# On double-click, run the remove_product_dialog method.
	self.signal_connect("row-activated") do |tree_view, path, column|
	  self.delete_selected
	end
	
	# Tree View settings.
	self.reorderable = true
	
	return self
  end
  
  def clear_sort
	# Sort by the index column.
	@system_view_planets_store.set_sort_column_id(0)
  end
  
  def edit_selected
	# Get a tree iter to the selected row.
	row = self.selection
	tree_iter = row.selected
	
	# If the user hasn't selected any rows, tree_iter will be nil.
	# In that case, return.
	if (tree_iter == nil)
	  return
	end
	
	selected_planet_instance = tree_iter.get_value(1)
	
	# Create a new PlanetViewWidget, passing in the selected planet.
	$ruby_pi_main_gtk_window.change_main_widget(PlanetViewWidget.new(selected_planet_instance))
  end
  
  def delete_selected
	# Get a tree iter to the selected row.
	row = self.selection
	tree_iter = row.selected
	
	selected_planet_instance = tree_iter.get_value(1)
	
	@pi_configuration_model.remove_planet(selected_planet_instance)
  end
  
  def pi_configuration_model=(new_pi_configuration_model)
	# Pass new model along to store.
	@system_view_planets_store.pi_configuration_model=(new_pi_configuration_model)
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