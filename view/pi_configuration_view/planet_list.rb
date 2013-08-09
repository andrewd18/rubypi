require_relative 'planet_list_store.rb'

require_relative '../gtk_helpers/icon_column.rb'
require_relative '../gtk_helpers/text_column.rb'
require_relative '../gtk_helpers/text_column_with_image_header.rb'
require_relative '../gtk_helpers/progress_bar_column.rb'

class PlanetList < Gtk::TreeView
  def initialize(controller)
	super()
	
	@controller = controller
	
	# Signals
	self.signal_connect("row-activated") do |treeview, path, column|
	  unless (self.selected_planet_instance == nil)
		@controller.remove_planet(self.selected_planet_instance)
	  end
	end
	
	# Create columns for the tree view.
	icon_column = IconColumn.new("", 1)
	name_column = TextColumn.new("Name", 2)
	pct_powergrid_usage_column = ProgressBarColumn.new("PG Usage", 3, 4)  # Header, Actual Value, Pct to Fill Bar
	pct_cpu_usage_column = ProgressBarColumn.new("CPU Usage", 5, 6)  # Header, Actual Value, Pct to Fill Bar
	num_extractors_column = TextColumnWithImageHeader.new("view/images/minimalistic_extractor_icon.png", 7)
	num_factories_column = TextColumnWithImageHeader.new("view/images/minimalistic_factory_icon.png", 8)
	num_storages_column = TextColumnWithImageHeader.new("view/images/minimalistic_storage_facility_icon.png", 9)
	num_launchpads_column = TextColumnWithImageHeader.new("view/images/minimalistic_launchpad_icon.png", 10)
	
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
	
	# Tree View settings.
	self.reorderable = true
	
	return self
  end
  
  def pi_configuration_model=(new_model)
	list_store = PlanetListStore.new(new_model)
	self.model = list_store
  end
  
  def selected_planet_instance
	row = self.selection
	tree_iter = row.selected
	
	if (tree_iter == nil)
	  return nil
	else
	  selected_planet_instance = tree_iter.get_value(0)
	  return selected_planet_instance
	end
  end
end