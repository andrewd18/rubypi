require 'gtk3'

class SaveBeforeQuitDialog < Gtk::MessageDialog
  
  def initialize(parent = nil)
	parent_window = parent
	flags = Gtk::Dialog::Flags::MODAL
	type = Gtk::MessageType::QUESTION
	
	message = "Do you want to save before closing?"
	
	super(:parent => parent_window, :flags => flags, :type => type, :buttons_type => Gtk::MessageDialog::ButtonsType::NONE, :message => message)
	
	self.add_button("Quit Without Saving", Gtk::ResponseType::NO)
	self.add_button("Save and Quit", Gtk::ResponseType::YES)
	self.add_button("Cancel", Gtk::ResponseType::REJECT)
	
	return self
  end
end