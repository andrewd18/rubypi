require 'gtk3'
require_relative 'select_building_combo_box.rb'

class ExpeditedTransferDialog < Gtk::Dialog
  attr_reader :hash_to_transfer
  
  def initialize(building_model)
	title = "Expedited Transfer"
	parent_window = nil
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	second_button_response_id_combo = [Gtk::Stock::CANCEL, Gtk::ResponseType::REJECT]
	
	@building_model = building_model
	@planet_model = @building_model.planet
	
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo, second_button_response_id_combo])
	
	# Fill top of dialog in.
	
	# TODO
	# self.vbox.add(widget)
	destination_label = Gtk::Label.new("Transfer products to:")
	
	
	@destination_combo_box = SelectBuildingComboBox.new(@planet_model.aggregate_launchpads_ccs_storages)
	
	destination_row = Gtk::Box.new(:horizontal)
	
	destination_row.add(destination_label)
	destination_row.add(@destination_combo_box)
	
	self.child.add(destination_row)
	
	
	
	# List of Products
	
	@hash_to_transfer = Hash.new
	
	@building_model.stored_products.each_pair do |product_name, currently_stored_quantity|
	  product_name_label = Gtk::Label.new("#{product_name}")
	                                                      #min, max,                    #scale
	  product_quantity_slider = Gtk::Scale.new(:horizontal, 0, currently_stored_quantity, 1)
	  
	  # Make values visible to calling object.
	  @hash_to_transfer[product_name] = product_quantity_slider.value
	  
	  # Make labels and sliders visible on screen.
	  
	  row = Gtk::Box.new(:horizontal)
	  row.add(product_name_label)
	  row.add(product_quantity_slider)
	  
	  self.vbox.add(row)
	end
	
	# 1. Show list of stored products.
	# 2. Let user select products.
	# 3. Let user select quantity of each product.
	# 4. Let user select destination from @planet_model.aggregate_launchpads_ccs_storages (minus self)
	# 5. Make this full list of selected things and destination accessible.
	# 6. Parent object will do the lifting.
	
	self.show_all
	
	return self
  end
  
  def destination
	return @destination_combo_box.selected_item
  end
end