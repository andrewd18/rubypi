# Given a list or tree view, calls its edit_selected function.

class EditSelectedButton < Gtk::Button
  def initialize(view)
	raise ArgumentError, "Passed in view is not a list or tree view." unless ((view.is_a?(Gtk::TreeView)) or (view.is_a?(Gtk::ListView)))
	raise ArgumentError, "Passed in view does not respond to 'edit_selected' method." unless (view.respond_to?("edit_selected"))
	
	super(:stock_id => Gtk::Stock::EDIT)
	
	self.signal_connect("clicked") do
	  view.edit_selected
	end
  end
end
