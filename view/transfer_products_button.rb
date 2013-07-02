require 'gtk3'

require_relative 'transfer_products_dialog.rb'

# When clicked, creates a transfer products dialog.
# If the dialog sends the accepted signal, do the heavy lifting of the transfer at the model level.

# This should be able to handle both expedited transfers and POCO import/exports.
# Show tax / cost as necessary.

class TransferProductsButton < Gtk::Button
  def initialize(planet_model, source_building = nil, parent_window = nil)
	super(:label => "Transfer Products")
	
	@planet_model = planet_model
	@source_building = source_building
	@parent_window = parent_window
	
	self.signal_connect("clicked") do
	  self.create_transfer_dialog
	end
	
	return self
  end
  
  def create_transfer_dialog
	dialog = TransferProductsDialog.new(@planet_model, @source_building, @parent_window)
	dialog.run do |response|
	  # Don't do anything on a response.
	  # The TransferProductsDialog handles everything itself.
	end
	
	# Remove the dialog now that we've acted on it.
	dialog.destroy
  end
end