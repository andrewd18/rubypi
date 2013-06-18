require 'gtk3'

class ExpeditedTransferDialog < Gtk::Dialog
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
	# 1. Show list of stored products.
	# 2. Let user select products.
	# 3. Let user select quantity of each product.
	# 4. Let user select destination from @planet_model.aggregate_launchpads_ccs_storages (minus self)
	# 5. Make this full list of selected things and destination accessible.
	# 6. Parent object will do the lifting.
	
	return self
  end
end