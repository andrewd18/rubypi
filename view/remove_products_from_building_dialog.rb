require 'gtk3'

class RemoveProductsFromBuildingDialog < Gtk::Dialog
  attr_reader :quantity
  
  def initialize(building_model, product_name)
	title = "Remove Products from Building"
	parent_window = nil
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	second_button_response_id_combo = [Gtk::Stock::CANCEL, Gtk::ResponseType::REJECT]
	
	@building_model = building_model
	
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo, second_button_response_id_combo])
	
	
	currently_stored_quantity = @building_model.stored_products[product_name]
	
	# Fill top of dialog in.
	how_many_label = Gtk::Label.new("How Many?")
	@product_quantity_slider = Gtk::Scale.new(:horizontal, 0, currently_stored_quantity, 1)
	
	self.child.add(how_many_label)
	self.child.add(@product_quantity_slider)
	
	self.show_all
	
	return self
  end
  
  def quantity
	return @product_quantity_slider.value
  end
end