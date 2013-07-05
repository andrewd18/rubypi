require 'gtk3'

require_relative 'launch_products_to_space_dialog.rb'

# When clicked, creates a launch products to space dialog.

class LaunchProductsToSpaceButton < Gtk::Button
  def initialize(command_center, parent_window = nil)
	super(:label => "Launch Products to Space")
	
	@command_center = command_center
	@parent_window = parent_window
	
	self.signal_connect("clicked") do
	  self.create_launch_dialog
	end
	
	return self
  end
  
  def create_launch_dialog
	dialog = LaunchProductsToSpaceDialog.new(@command_center, @parent_window)
	dialog.run do |response|
	  # Don't do anything on a response.
	  # The LaunchProductsToSpaceDialog handles everything itself.
	end
	
	# Remove the dialog now that we've acted on it.
	dialog.destroy
  end
end