# Given a planet, lists the products the planet imports.

require_relative '../gtk_helpers/text_column.rb'
require_relative 'planet_export_list_store.rb'

class PlanetExportList < Gtk::TreeView
  def initialize(planet_model = nil)
	@list_store = PlanetExportListStore.new(planet_model)
	
	super(@list_store)
	
	self.set_headers_visible(false)
	
	name_column = TextColumn.new("Name", 1)
	quantity_column = TextColumn.new("Quantity", 2)
	
	# Tell the name column to expand before the others do.
	name_column.expand = true
	
	# Pack columns in tree view, left-to-right.
	self.append_column(name_column)
	self.append_column(quantity_column)
	
	return self
  end

  def planet_model=(new_planet_model)
	@list_store.planet_model = new_planet_model
  end
  
  def destroy
	@list_store.destroy
	
	super
  end
end