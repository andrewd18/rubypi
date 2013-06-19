
require 'gtk3'

require_relative 'expedited_transfer_button.rb'
require_relative 'add_products_widget.rb'

# This widget provides all the options necessary to edit a Launchpad.
class EditLaunchpadWidget < Gtk::Box
  
  attr_accessor :building_model
  
  def initialize(building_model)
	super(:horizontal)
	
	# Hook up model data.
	@building_model = building_model
	
	# Create widgets.
	add_products_label = Gtk::Label.new("Add Products:")
	@add_products_widget = AddProductsWidget.new
	
	stored_products_label = Gtk::Label.new("Stored Products:")
	@stored_products_store = StoredProductsListStore.new(@building_model)
	@stored_products_list_view = StoredProductsTreeView.new(@stored_products_store)
	expedited_transfer_button = ExpeditedTransferButton.new(@building_model)
	
	# Add pack widgets into columns, then pack columns left to right.
	# Left Column.
	add_products_column = Gtk::Box.new(:vertical)
	add_products_column.pack_start(add_products_label, :expand => false)
	add_products_column.pack_start(@add_products_widget, :expand => true)
	self.pack_start(add_products_column)
	
	# Right column.
	stored_products_column = Gtk::Box.new(:vertical)
	stored_products_column.pack_start(stored_products_label, :expand => false)
	stored_products_column.pack_start(@stored_products_list_view , :expand => true)
	stored_products_column.pack_start(expedited_transfer_button, :expand => false)
	self.pack_start(stored_products_column)
	
	# Set the active iterater from the model data.
	# Since #update does this, call #update.
	update
	
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