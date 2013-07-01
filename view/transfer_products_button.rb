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
	  # Don't do anything on a response.
	  # The TransferProductsDialog handles everything itself.
	end
	
	# Remove the dialog now that we've acted on it.
	dialog.destroy
  end
end