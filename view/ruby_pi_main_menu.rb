require 'gtk3'

require_relative 'save_to_yaml_dialog.rb'
require_relative 'load_from_yaml_dialog.rb'
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
	
	file_submenu_save = Gtk::MenuItem.new("Save")
	file_submenu_load = Gtk::MenuItem.new("Load")
	file_submenu_quit = Gtk::MenuItem.new("Quit")
	
	# Signal connection for File -> Save
	file_submenu_save.signal_connect("activate") do
	  self.save_to_yaml
	end
	
	# Signal connection for File -> Load
	file_submenu_load.signal_connect("activate") do
	  self.load_from_yaml
	end
	
	# Signal connection for File -> Quit.
	file_submenu_quit.signal_connect("activate") do
	  $ruby_pi_main_gtk_window.close_application
	end
	
	file_submenu.append(file_submenu_save)
	file_submenu.append(file_submenu_load)
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
  
  def save_to_yaml
	dialog = SaveToYamlDialog.new($ruby_pi_main_gtk_window)
	
	# Run the dialog.
	if dialog.run == Gtk::ResponseType::ACCEPT
	  # Get the filename the user gave us.
	  user_set_filename = dialog.filename
	  
	  # Append .yml to it, if necessary.
	  unless (user_set_filename.end_with?(".yml"))
		user_set_filename += ".yml"
	  end
	  
	  $ruby_pi_main_gtk_window.main_widget.stop_observing_model
	  
	  PIConfiguration.save_to_yaml($ruby_pi_main_gtk_window.pi_configuration, user_set_filename)
	  
	  $ruby_pi_main_gtk_window.main_widget.start_observing_model
	end
	
	dialog.destroy
  end
  
  def load_from_yaml
	dialog = LoadFromYamlDialog.new($ruby_pi_main_gtk_window)
	
	# Run the dialog.
	if dialog.run == Gtk::ResponseType::ACCEPT
	  loaded_pi_configuration = PIConfiguration.load_from_yaml(dialog.filename)
	  $ruby_pi_main_gtk_window.pi_configuration = loaded_pi_configuration
	  
	  # Reset to System View Widget.
	  # 
	  # I do this because System View Widget is the only view that accepts a top-level pi_configuration model object,
	  # instead of a specific sub-object, like a planet or building.
	  #
	  # Also it makes a certain amount of sense; if you load a PI config, you should be able to see it at-a-glance.
	  # Changing all the values of the planet you're looking at, for example, without an at-a-glance overview
	  # might be disorienting.
	  $ruby_pi_main_gtk_window.change_main_widget(SystemViewWidget.new($ruby_pi_main_gtk_window.pi_configuration))
	end
	
	dialog.destroy
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