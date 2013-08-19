require 'gtk3'

class RemoveProductsFromBuildingDialog < Gtk::Dialog
  attr_reader :quantity
  
  def initialize(building_model, product_name, parent_window = nil)
	title = "Remove #{product_name} from #{building_model.name}"
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	second_button_response_id_combo = [Gtk::Stock::CANCEL, Gtk::ResponseType::REJECT]
	
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo, second_button_response_id_combo])
	
	currently_stored_quantity = building_model.stored_products[product_name]
	
	# Fill top of dialog in.
	how_many_label = Gtk::Label.new("Remove #{product_name} from #{building_model.name}")
	@product_quantity_slider = Gtk::Scale.new(:horizontal, 0, currently_stored_quantity, 1)
	
	# WORKAROUND
	# "self.child" is actually a vbox which we connect things to via pack_start.
	# For some reason self.vbox is deprecated. :/
	self.child.pack_start(how_many_label, :expand => false)
	self.child.pack_start(@product_quantity_slider, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def quantity
	return @product_quantity_slider.value
  end
end