require 'gtk3'

# Holds a lists of products stored in the building.
# Uses "stored_products" accessor from UnrestrictedStorage and IndustrialFacilityStorage modules.
class NameQuantityHashListStore < Gtk::ListStore
  def initialize(hash = {})
	# Set up columns.
	super(Gdk::Pixbuf,	# Icon
	      String,		# Name
	      Integer,		# Quantity
	      )
	
	@name_quantity_hash = hash
	
	return self
  end
  
  def name_quantity_hash=(new_hash)
	@name_quantity_hash = new_hash
	self.update
  end
  
  # Called when the building says it changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  self.clear
	  
	  # Update list from model.
	  @name_quantity_hash.each_pair do |product_name, quantity_stored|
		new_row = self.append
		# new_row.set_value(0, ProductImage.new(product_name, [32, 32]).pixbuf)
		new_row.set_value(1, product_name)
		new_row.set_value(2, quantity_stored)
	  end
	end
  end
end