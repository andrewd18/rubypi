
require 'gtk3'


# This widget provides all the options necessary to edit an Extractor.
class EditLaunchpadWidget < Gtk::Box
  
  attr_accessor :building_model
  
  def initialize(building_model)
	super(:vertical)
	
	# Hook up model data.
	@building_model = building_model
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	# Add planet building stats widgets in a nice grid.
	launchpad_table = Gtk::Table.new(7, 2)
	
	# Stored Products Row
	stored_products_label = Gtk::Label.new("Stored Products:")
	
	# Table of stored products.
	@stored_products_store = StoredProductsListStore.new(@building_model)
	@stored_products_list_view = StoredProductsTreeView.new(@stored_products_store)
	
	
	# Set the active iterater from the model data.
	# Since #update does this, call #update.
	update
	
	
	launchpad_table.attach(stored_products_label, 0, 1, 0, 1)
	launchpad_table.attach(@stored_products_list_view, 1, 2, 0, 1)
	
	self.pack_start(launchpad_table, :expand => false)
	
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
	  # do nothing
	end
  end
  
  def commit_to_model
	# Do nothing.
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