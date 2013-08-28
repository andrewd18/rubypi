require 'gtk3'

require_relative 'launch_to_can_dialog.rb'

# When clicked, creates a transfer products dialog.

class LaunchProductsToSpaceButton < Gtk::Button
  def initialize(controller, command_center, parent_window = nil)
	super(:label => "Launch to Space")
	
	@controller = controller
	@command_center = command_center
	@parent_window = parent_window
	
	self.signal_connect("clicked") do
	  self.create_transfer_dialog
	end
	
	return self
  end
  
  def create_transfer_dialog
	dialog = LaunchToCanDialog.new(@command_center, @parent_window)
	dialog.run do |response|
	  if (response == Gtk::ResponseType::ACCEPT)
		# Perform the transfer, overwriting the real model with the values from the dialog.
		@controller.overwrite_storage(dialog.command_center_stored_products_hash)
	  end
	end
	
	# Remove the dialog now that we've acted on it.
	dialog.destroy
  end
  
  def building_model=(new_building_model)
	@command_center = new_building_model
  end
end