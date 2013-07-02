require 'gtk3'

class AddProductsSelectQuantityDialog < Gtk::Dialog
  attr_reader :quantity
  
  def initialize(building_model, product_name, parent_window = nil)
	title = "Add Products to Building"
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	second_button_response_id_combo = [Gtk::Stock::CANCEL, Gtk::ResponseType::REJECT]
	
	@building_model = building_model
	
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo, second_button_response_id_combo])
	
	product_instance = Product.find_by_name(product_name)
	most_amount_addable = (@building_model.volume_available / product_instance.volume)
	# Force an int.
	most_amount_addable = most_amount_addable.to_i
	
	# Fill top of dialog in.
	how_many_label = Gtk::Label.new("How Many?")
	@product_quantity_slider = Gtk::Scale.new(:horizontal, 0, most_amount_addable, 1)
	
	self.child.add(how_many_label)
	self.child.add(@product_quantity_slider)
	
	self.show_all
	
	return self
  end
  
  def quantity
	return @product_quantity_slider.value
  end
end