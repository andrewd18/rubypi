require 'gtk3'

class AddProductsSelectQuantityDialog < Gtk::Dialog
  attr_reader :quantity
  
  def initialize(building_model, product_name, parent_window = nil)
	title = "Add #{product_name} to #{building_model.name}"
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	second_button_response_id_combo = [Gtk::Stock::CANCEL, Gtk::ResponseType::REJECT]
	
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo, second_button_response_id_combo])
	
	product_instance = Product.find_by_name(product_name)
	most_amount_addable = (building_model.volume_available / product_instance.volume)
	# Force an int.
	most_amount_addable = most_amount_addable.to_i
	
	product_name_label = Gtk::Label.new("Add #{product_name} to #{building_model.name}")
	@product_quantity_slider = Gtk::Scale.new(:horizontal, 0, most_amount_addable, 1)
	
	# WORKAROUND
	# "self.child" is actually a vbox which we connect things to via pack_start.
	# For some reason self.vbox is deprecated. :/
	self.child.pack_start(product_name_label, :expand => false)
	self.child.pack_start(@product_quantity_slider, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def quantity
	return @product_quantity_slider.value
  end
end