require 'gtk3'

require_relative '../../model/schematic.rb'
require_relative '../common/select_building_combo_box.rb'
require_relative '../common/building_image.rb'
require_relative '../common/stored_products_widget.rb'

require_relative '../gtk_helpers/simple_combo_box.rb'
require_relative '../gtk_helpers/simple_table.rb'

# This widget provides all the options necessary to edit a BasicIndustrialFacility, AdvancedIndustrialFacility, or HighTechIndustrialFacility.
class PlanetaryLinkView < Gtk::Box
  
  def initialize(controller)
	super(:vertical)
	
	@controller = controller
	
	# Create the top row.
	# Top row should contain a label stating what view we're looking at, followed by an UP button.
	top_row = Gtk::Box.new(:horizontal)
	
	planetary_link_view_label = Gtk::Label.new("Planetary Link View")
	
	# Add our up button.
	@up_button = UpToPlanetViewButton.new(@controller)
	
	top_row.pack_start(planetary_link_view_label, :expand => true)
	top_row.pack_start(@up_button, :expand => false)
	self.pack_start(top_row, :expand => false)
	
	
	# Create the bottom row.
	# Bottom row should contain the specialized widget that lets you edit the building's model.
	bottom_row = Gtk::Box.new(:horizontal)
	
	# Source Building
	source_building_label = Gtk::Label.new("Source Building")
	@source_building_image = BuildingImage.new
	source_building_vbox = Gtk::Box.new(:vertical)
	source_building_vbox.pack_start(source_building_label, :expand => false)
	source_building_vbox.pack_start(@source_building_image, :expand => false)
	source_building_frame = Gtk::Frame.new
	source_building_frame.add(source_building_vbox)
	
	
	# Link Column
	link_label = Gtk::Label.new("Link")
	link_image = Gtk::Image.new(:file => "view/images/64x64/link_icon_lr.png")
	
	link_stats_table = SimpleTable.new(5, 2)
	
	
	link_upgrade_level_label = Gtk::Label.new("Upgrade Level:")
	                                             # min, max, step
	@link_upgrade_level_spinner = Gtk::SpinButton.new(1, 10, 1)
	link_stats_table.attach(link_upgrade_level_label, 1, 1)
	link_stats_table.attach(@link_upgrade_level_spinner, 1, 2)
	
	# Set up signal.
	@on_level_changed_signal = @link_upgrade_level_spinner.signal_connect("value-changed") do |spinner|
	  @controller.change_upgrade_level(spinner.value)
	end
	
	
	link_transfer_volume_label = Gtk::Label.new("Transfer Volume:")
	@link_transfer_volume_value = Gtk::Label.new("1250 m3")
	link_stats_table.attach(link_transfer_volume_label, 2, 1)
	link_stats_table.attach(@link_transfer_volume_value, 2, 2)
	
	link_length_label = Gtk::Label.new("Length:")
	@link_length_value = Gtk::Label.new("50 km")
	link_stats_table.attach(link_length_label, 3, 1)
	link_stats_table.attach(@link_length_value, 3, 2)
	
	link_pg_usage_label = Gtk::Label.new("PG Usage:")
	@link_pg_usage_value = Gtk::Label.new("0 MW")
	link_stats_table.attach(link_pg_usage_label, 4, 1)
	link_stats_table.attach(@link_pg_usage_value, 4, 2)
	
	link_cpu_usage_label = Gtk::Label.new("CPU Usage:")
	@link_cpu_usage_value = Gtk::Label.new("0 TF")
	link_stats_table.attach(link_cpu_usage_label, 5, 1)
	link_stats_table.attach(@link_cpu_usage_value, 5, 2)
	
	
	link_vbox = Gtk::Box.new(:vertical)
	link_vbox.pack_start(link_label, :expand => false)
	link_vbox.pack_start(link_image, :expand => false)
	link_vbox.pack_start(link_stats_table, :expand => false)
	
	link_frame = Gtk::Frame.new
	link_frame.add(link_vbox)
	
	# Destination Building
	destination_building_label = Gtk::Label.new("Destination Building")
	@destination_building_image = BuildingImage.new
	destination_building_vbox = Gtk::Box.new(:vertical)
	destination_building_vbox.pack_start(destination_building_label, :expand => false)
	destination_building_vbox.pack_start(@destination_building_image, :expand => false)
	destination_building_frame = Gtk::Frame.new
	destination_building_frame.add(destination_building_vbox)
	
	
	# Pack left to right.
	bottom_row.pack_start(source_building_frame, :expand => true)
	bottom_row.pack_start(link_frame, :expand => true)
	bottom_row.pack_start(destination_building_frame, :expand => true)
	
	self.pack_start(bottom_row, :expand => true)
	
	self.show_all
	
	return self
  end
  
  def link_model=(new_link_model)
	@link_model = new_link_model
	
	# Update self widgets.
	@link_transfer_volume_value.text = ("#{@link_model.transfer_volume} m3")
	@link_length_value.text = ("#{@link_model.length.to_int} km")
	@link_pg_usage_value.text = ("#{@link_model.powergrid_usage} MW")
	@link_cpu_usage_value.text = ("#{@link_model.cpu_usage} TF")
	
	# WORKAROUND
	# I wrap the view-update events in signal_handler_block(id) closures.
	# This temporarily nullifies the objects from sending GTK signal I previously hooked up.
	
	@link_upgrade_level_spinner.signal_handler_block(@on_level_changed_signal) do
	  @link_upgrade_level_spinner.value=(@link_model.upgrade_level)
	end
	
	# Pass to children.
	@source_building_image.building_model = @link_model.source_building
	@destination_building_image.building_model = @link_model.destination_building
  end
end