require 'gtk3'

class TransferProductsSelectQuantityDialog < Gtk::Dialog
  attr_reader :quantity
  
  def initialize(product_name, max_transferrable_quantity, parent_window = nil)
	# Dialog options.
	title = "Transfer #{product_name}"
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	second_button_response_id_combo = [Gtk::Stock::CANCEL, Gtk::ResponseType::REJECT]
	
	# Create the dialog.
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo, second_button_response_id_combo])
	
	product_name_label = Gtk::Label.new("#{product_name}")
	
	# Create the slider.
												# min,   #max,   # adjust_by
	@product_quantity_slider = Gtk::Scale.new(:horizontal, 0, max_transferrable_quantity, 1)
	
	# Request a minimum of 150 pixels wide.
	@product_quantity_slider.width_request = 150
	
	vbox = Gtk::Box.new(:vertical)
	vbox.pack_start(product_name_label, :expand => false)
	vbox.pack_start(@product_quantity_slider, :expand => false)
	
	self.child.add(vbox)
	self.show_all
	
	return self
  end
  
  def quantity
	return @product_quantity_slider.value
  end
end