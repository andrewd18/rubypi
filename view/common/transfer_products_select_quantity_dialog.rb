require 'gtk3'
require_relative '../planet_view/isk_amount_label.rb'
require_relative '../../model/product.rb'

require_relative '../gtk_helpers/simple_table.rb'

class TransferProductsSelectQuantityDialog < Gtk::Dialog
  attr_reader :quantity
  
  def initialize(source_building, destination_building, product_name, parent_window = nil)
	# Dialog options.
	title = "Transfer #{product_name} to #{destination_building.name}"
	flags = Gtk::Dialog::Flags::MODAL
	first_button_response_id_combo = [Gtk::Stock::OK, Gtk::ResponseType::ACCEPT]
	second_button_response_id_combo = [Gtk::Stock::CANCEL, Gtk::ResponseType::REJECT]
	
	# Create the dialog.
	super(:title => title, :parent => parent_window, :flags => flags, :buttons => [first_button_response_id_combo, second_button_response_id_combo])
	
	transfer_layout_table = SimpleTable.new(2, 2, false)
	
	
	product_name_label = Gtk::Label.new("#{product_name}")
	
	
	# Amount slider.
	#
	product_instance = Product.find_by_name(product_name)
	
	max_transferrable_quantity = ((destination_building.volume_available) / (product_instance.volume))
	max_transferrable_quantity = max_transferrable_quantity.to_int
	
	quantity_stored_in_source = source_building.stored_products[product_name]
	
	# Create and limit the slider.
	# If you've got more product than the destination can hold, your top limit is the destination volume.
	# If you've got less product than the destination can hold, your top limit is the product amount.
	if (quantity_stored_in_source > max_transferrable_quantity)
	  														# min,        #max,   # adjust_by
	  @product_quantity_slider = Gtk::Scale.new(:horizontal, 0, max_transferrable_quantity, 1)
	else
	  														# min,        #max,   # adjust_by
	  @product_quantity_slider = Gtk::Scale.new(:horizontal, 0, quantity_stored_in_source, 1)
	end
	
	# Request 150 pixels wide.
	@product_quantity_slider.width_request = 150
	
	
	transfer_layout_table.attach(product_name_label, 1, 1, false, false, false, false)
	transfer_layout_table.attach(@product_quantity_slider, 1, 2, true, true, false, false)
	
	
	
	if (source_building.is_a?(CustomsOffice) or
	    destination_building.is_a?(CustomsOffice))
	  
	  cost_label = Gtk::Label.new("Import / Export Cost:")
	  transfer_layout_table.attach(cost_label, 2, 1, false, false, false, false)
	  
	  @isk_amount_label = IskAmountLabel.new
	  transfer_layout_table.attach(@isk_amount_label, 2, 2, false, false, false, false)
	  
	  # When the quantity changes, ask the customs office how much this will be.
	  @product_quantity_slider.signal_connect("value-changed") do
		
		if (source_building.is_a?(CustomsOffice))
		  # This is a planetary import.
		  @isk_amount_label.isk_value = source_building.import_cost_with_tax(product_name, @product_quantity_slider.value)
		  
		elsif (destination_building.is_a?(CustomsOffice))
		  # This is a planetary export.
		  @isk_amount_label.isk_value = destination_building.export_cost_with_tax(product_name, @product_quantity_slider.value)
		end
	  end
	  
	  
	#elsif (destination_building.is_a?(LaunchCan))
	  # Then this poor bastard is doing a planetary launch from a command center because he's too poor to afford POCOs.
	  #cost_label = Gtk::Label.new("Launch Cost:")
	  #transfer_layout_table.attach(cost_label, 2, 1, false, false, false, false)
	  
	  #@isk_amount_label = IskAmountLabel.new
	  #transfer_layout_table.attach(@isk_amount_label, 2, 2, false, false, false, false)
	  
	  # When the quantity changes, ask the command center how much this will be.
	  #@product_quantity_slider.signal_connect("value-changed") do
		#@isk_amount_label.isk_value = source_building.launch_to_space_cost(product_name, @product_quantity_slider.value)
	  #end
	  
	else
	  # Don't need to show any tax value as it's technically an "expedited transfer".
	end
	
	
	self.child.add(transfer_layout_table)
	self.show_all
	
	return self
  end
  
  def quantity
	return @product_quantity_slider.value
  end
end