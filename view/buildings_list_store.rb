require 'gtk3'

class BuildingsListStore < Gtk::ListStore
  
  attr_accessor :planet_model
  
  def initialize(planet_model)
	
	@planet_model = planet_model
	
	# Set up columns.
	super(Integer,				# Index
	      PlanetaryBuilding,	# Building instance.
	      Gdk::Pixbuf,			# Icon
	      String,				# Name
	      String,				# Stored Products
	      String,				# Produces (Product Name)
	      Integer,				# PG Used
	      Integer,				# CPU Used
	      Integer				# ISK Cost
	      )
	
	# Update self from @planet_model.
	self.update
	
	return self
  end
  
  def delete_building(list_iter)
	# Get the exact building instance the user wants to remove.
	# Pull this from the Instance column.
	building_instance = list_iter.get_value(1)
	
	@planet_model.remove_building(building_instance)
  end
  
  def start_observing_model
	@planet_model.add_observer(self)
  end
  
  def stop_observing_model
	@planet_model.delete_observer(self)
  end
  
  # Called when the planet says it changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  self.clear
	  
	  # Update planet building list from model.
	  @planet_model.buildings.each_with_index do |building, index|
		new_row = self.append
		new_row.set_value(0, index)
		new_row.set_value(1, building)
		new_row.set_value(2, BuildingImage.new(building, [32, 32]).pixbuf)
		new_row.set_value(3, building.name)
		
		# Stored Products
		if (building.respond_to?(:stored_products))
		  stored_products_string_for_display = ""
		  
		  building.stored_products.each_pair do |product_name, quantity_stored|
			# Product Name: Qty Stored
			stored_products_string_for_display.concat("#{product_name}")
			stored_products_string_for_display.concat(": ")
			stored_products_string_for_display.concat("#{quantity_stored}")
			# New line
			stored_products_string_for_display.concat("\n")
		  end
		  
		  new_row.set_value(4, "#{stored_products_string_for_display}")
		  
		else
		  new_row.set_value(4, "")
		end
		
		# Product Name
		if (building.respond_to?(:produces_product_name))
		  new_row.set_value(5, building.produces_product_name)
		else
		  new_row.set_value(5, "")
		end
		
		new_row.set_value(6, building.powergrid_usage)
		new_row.set_value(7, building.cpu_usage)
		new_row.set_value(8, building.isk_cost)
	  end
	end
  end
  
  def destroy
	self.stop_observing_model
  end
end