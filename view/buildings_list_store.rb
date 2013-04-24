class BuildingsListStore < Gtk::ListStore
  
  # TODO - Implement a "resort by order in @planet_model.buildings" function.
  
  def initialize(planet_model)
	
	@planet_model = planet_model
	@planet_model.add_observer(self)
	
	# Set up columns.
	super(Integer,		# UID
	      Gdk::Pixbuf,	# Icon
	      String,		# Name
	      String,		# Produces (Product Name)
	      Integer,		# PG Used
	      Integer,		# CPU Used
	      Integer		# ISK Cost
	      )
	
	# Update self from @planet_model.
	self.update
	
	return self
  end
  
  def delete_building(list_iter)
	# Get the iter for the building we want dead.
	building_iter_value = list_iter.get_value(0)
	
	# TODO - Delete specific building ID rather than relying on these iters matching.
	@planet_model.remove_building(@planet_model.buildings[building_iter_value])
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
		new_row.set_value(1, BuildingImage.new(building, [32, 32]).pixbuf)
		new_row.set_value(2, building.name)
		
		if (building.respond_to?(:produces_product_name))
		  new_row.set_value(3, building.produces_product_name)
		else
		  new_row.set_value(3, "")
		end
		
		new_row.set_value(4, building.powergrid_usage)
		new_row.set_value(5, building.cpu_usage)
		new_row.set_value(6, building.isk_cost)
	  end
	end
  end
  
  def destroy
	@planet_model.delete_observer(self)
  end
end