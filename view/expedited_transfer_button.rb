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
	  if (response == Gtk::ResponseType::ACCEPT)
		
		# For each product in the list, perform a transfer.
		dialog.hash_to_transfer.each_pair do |product_name, quantity_to_transfer|
		  
		  # Only transfer if the user is trying to transfer a greater-than-zero quantity.
		  if (quantity_to_transfer > 0)
			@building_model.remove_qty_of_product(product_name, quantity_to_transfer)
			
			dialog.destination.store_product(product_name, quantity_to_transfer)
		  else
			puts "User tried to transfer #{quantity_to_transfer} of #{product_name}, which would cause an ArgumentError."
		  end
		end
		
	  else
		puts "User canceled the expedited transfer."
	  end
	end
	
	# Remove the dialog now that we've acted on it.
	dialog.destroy
  end
end