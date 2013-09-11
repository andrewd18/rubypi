class PlanetExportListStore < Gtk::ListStore
  
  def initialize(planet_model)
	
	super(Gdk::Pixbuf, # Product icon.
	      String,      # Product name
	      Integer      # Quantity required per hour
	      )
	
	# Link to the model.
	@planet_model = planet_model
	
	# Populate self from model.
	self.update
	
	return self
  end
  
  def planet_model=(new_planet_model)
	@planet_model = new_planet_model
	
	self.update
  end
  
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  unless (@planet_model == nil)
		@planet_model.output_products_per_hour.each_pair do |product_name, quantity|
		  new_row = self.append
		  new_row.set_value(1, product_name)
		  new_row.set_value(2, quantity)
		end
	  end
	end
  end
end