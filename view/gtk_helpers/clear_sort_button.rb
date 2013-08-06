# Given a list or tree view, calls its clear_sort function.

class ClearSortButton < Gtk::Button
  def initialize(view)
	raise ArgumentError, "Passed in view is not a list or tree view." unless ((view.is_a?(Gtk::TreeView)) or (view.is_a?(Gtk::ListView)))
	raise ArgumentError, "Passed in view does not respond to 'clear_sort' method." unless (view.respond_to?("clear_sort"))
	
	super(:label => "Clear Sort")
	
	self.signal_connect("clicked") do
	  view.clear_sort
	end
  end
end