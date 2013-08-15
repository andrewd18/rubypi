require 'gtk3'

require_relative 'ruby_pi_about_dialog.rb'

class RubyPIMainMenu < Gtk::MenuBar
  def initialize
	super
	
	# Top Menu
	file_menu = Gtk::MenuItem.new("File")
	help_menu = Gtk::MenuItem.new("Help")
	self.append(file_menu)
	self.append(help_menu)
	
	# File ->
	file_submenu = Gtk::Menu.new
	
	file_submenu_quit = Gtk::MenuItem.new("Quit")
	
	# Signal connection for File -> Quit.
	file_submenu_quit.signal_connect("activate") do
	  $ruby_pi_main_gtk_window.close_application
	end
	
	file_submenu.append(file_submenu_quit)
	
	# Assign File -> to File
	file_menu.submenu = file_submenu
	
	
	
	
	# Help Menu ->
	help_submenu = Gtk::Menu.new
	
	help_submenu_about = Gtk::MenuItem.new("About")
	
	# Signal connection for About menu
	help_submenu_about.signal_connect("activate") do
	  show_about_dialog
	end
	
	help_submenu.append(help_submenu_about)
	
	# Assign File -> to File
	help_menu.submenu = help_submenu
	
	
	self.show_all
	
	return self
  end
  
  def show_about_dialog
	about_dialog = RubyPIAboutDialog.new
	
	about_dialog.run do |response|
	  about_dialog.destroy
	end
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end