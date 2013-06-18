
require 'gtk3'

require_relative 'expedited_transfer_button.rb'

# This widget provides all the options necessary to edit an Extractor.
class EditCommandCenterWidget < Gtk::Box
  
  attr_accessor :building_model
  
  def initialize(building_model)
	super(:vertical)
	
	# Hook up model data.
	@building_model = building_model
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	# Add planet building stats widgets in a nice grid.
	command_center_table = Gtk::Table.new(7, 2)
	
	# Upgrade Level Row
	upgrade_level_label = Gtk::Label.new("Upgrade Level:")
	
	# Create the spin button.						# min, max, step
	@upgrade_level_spin_button = Gtk::SpinButton.new(0, 5, 1)
	@upgrade_level_spin_button.numeric = true
	
	
	# Stored Products Row
	stored_products_label = Gtk::Label.new("Stored Products:")
	
	# Table of stored products.
	@stored_products_store = StoredProductsListStore.new(@building_model)
	@stored_products_list_view = StoredProductsTreeView.new(@stored_products_store)
	
	expedited_transfer_button = ExpeditedTransferButton.new(@building_model)
	
	# Set the active iterater from the model data.
	# Since #update does this, call #update.
	update
	
	
	command_center_table.attach(upgrade_level_label, 0, 1, 0, 1)
	command_center_table.attach(@upgrade_level_spin_button, 1, 2, 0, 1)
	
	command_center_table.attach(stored_products_label, 0, 1, 1, 2)
	command_center_table.attach(@stored_products_list_view, 1, 2, 1, 2)
	
	command_center_table.attach(expedited_transfer_button, 1, 2, 2, 3)
	
	self.pack_start(command_center_table, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def start_observing_model
	@building_model.add_observer(self)
	
	@stored_products_store.start_observing_model
  end
  
  def stop_observing_model
	@building_model.delete_observer(self)
	
	@stored_products_store.stop_observing_model
  end
  
  # Called when the factory_model changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @upgrade_level_spin_button.value = @building_model.upgrade_level
	end
  end
  
  def commit_to_model
	# Stop observing so the values we want to set don't get overwritten on an #update.
	self.stop_observing_model
	
	upgrade_level_int = @upgrade_level_spin_button.value.to_i
	
	@building_model.set_level(upgrade_level_int)
	
	# Start observing again.
	self.start_observing_model
  end
  
  def destroy
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	# This isn't packed so it doesn't get called automatically.
	@stored_products_store.destroy
	
	super
  end
end