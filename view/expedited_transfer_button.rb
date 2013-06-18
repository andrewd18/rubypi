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
		puts "accepted"
		# TODO
		# 1. Get dialog.products
		# 2. Get dialog.quantities
		# 3. Get dialog.destination
		# 4. Add/remove the appropriate values from the model.
		# 5. Show exception if necessary.
	  else
		puts "canceled"
	  end
	end
	
	dialog.destroy
  end
end