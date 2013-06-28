require 'gtk3'

require_relative 'transfer_products_dialog.rb'

# When clicked, creates a transfer products dialog.
# If the dialog sends the accepted signal, do the heavy lifting of the transfer at the model level.

# This should be able to handle both expedited transfers and POCO import/exports.
# Show tax / cost as necessary.

class TransferProductsButton < Gtk::Button
  def initialize(planet_model)
	super(:label => "Transfer Products")
	
	@planet_model = planet_model
	
	self.signal_connect("clicked") do
	  self.process_transfer
	end
	
	return self
  end
  
  def process_transfer
	dialog = TransferProductsDialog.new(@planet_model)
	dialog.run do |response|
	  if (response == Gtk::ResponseType::ACCEPT)
		
		# Performing a transfer of some kind. Figure out what's going on.
		
		# What buildings are we transferring between?
		source = dialog.source
		destination = dialog.destination
		
		# What products are we transferring?
		hash_to_transfer = dialog.hash_to_transfer
		
		# For each product in the list, perform a transfer.
		hash_to_transfer.each_pair do |product_name, quantity_to_transfer|
		  
		  # Only transfer if the user is trying to transfer a greater-than-zero quantity.
		  if (quantity_to_transfer > 0)
			source.remove_qty_of_product(product_name, quantity_to_transfer)
			
			destination.store_product(product_name, quantity_to_transfer)
		  end
		end
		
	  else
		puts "User canceled the transfer."
	  end
	end
	
	# Remove the dialog now that we've acted on it.
	dialog.destroy
  end
end