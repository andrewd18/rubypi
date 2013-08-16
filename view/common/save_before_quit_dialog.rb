require 'gtk3'

class SaveBeforeQuitDialog < Gtk::MessageDialog
  
  def initialize(parent = nil)
	parent_window = parent
	flags = Gtk::Dialog::Flags::MODAL
	type = Gtk::MessageType::QUESTION
	buttons = Gtk::MessageDialog::ButtonsType::YES_NO
	message = "Do you want to save before closing?"
	
	super(:parent => parent_window, :flags => flags, :type => type, :buttons_type => buttons, :message => message)
	
	return self
  end
end