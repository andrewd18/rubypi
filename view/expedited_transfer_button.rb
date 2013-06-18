require 'gtk3'

require_relative 'expedited_transfer_dialog.rb'

# When clicked, creates an expedited transfer dialog.
# If the dialog sends the accepted signal, do the heavy lifting of the transfer at the model level.

class ExpeditedTransferButton < Gtk::Button
  def initialize(building_model)
	super(:label => "Expedited Transfer")
	
	@building_model = building_model
	
	self.signal_connect("clicked") do
	  self.process_expedited_transfer
	end
	
	return self
  end
  
  def process_expedited_transfer
	dialog = ExpeditedTransferDialog.new(@building_model)
	dialog.run do |response|
	  case response
	  when Gtk::ResponseType::ACCEPT
		dialog.hash_to_transfer.each_pair do |product_name, quantity_to_transfer|
		  
		  @building_model.remove_qty_of_product(product_name, quantity_to_transfer)
		  
		  dialog.destination.store_product(product_name, quantity_to_transfer)
		end
		
		# TODO
		# 1. Show exception if necessary.
		
	  else
		puts "canceled"
	  end
	end
	
	dialog.destroy
  end
end