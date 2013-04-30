require 'gtk3'

require_relative 'ruby_pi_about_dialog.rb'

class RubyPIMainMenu < Gtk::MenuBar
  def initialize
	super
	
	# TODO - Make this class _not_ be a steaming pile of shit.
	
	
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
	
	# TODO - Should probably move these into a subclass.
	# Signal connection for File -> Save
	file_submenu_save.signal_connect("activate") do
	  dialog = Gtk::FileChooserDialog.new(:title => "Save File",
	                                      :parent => $ruby_pi_main_gtk_window,
	                                      :action => Gtk::FileChooser::Action::SAVE,
	                                      :buttons => [
	                                                   [Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL],
	                                                   [Gtk::Stock::SAVE, Gtk::ResponseType::ACCEPT]
	                                                  ]
	                                     )
	  
	  # Set up dialog options.
	  ruby_pi_folder = File.expand_path("..", File.dirname(__FILE__))
	  dialog.current_folder=(ruby_pi_folder)
	  dialog.do_overwrite_confirmation = true
	  
	  # Filter by file type.
	  yaml_filter = Gtk::FileFilter.new
	  yaml_filter.add_pattern("*.yml")
	  yaml_filter.name=("YAML")
	  
	  dialog.add_filter(yaml_filter)
	  
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
	
	
	# TODO - Should probably move these into a subclass.
	# Signal connection for File -> Load
	file_submenu_load.signal_connect("activate") do
	  dialog = Gtk::FileChooserDialog.new(:title => "Save File",
	                                      :parent => $ruby_pi_main_gtk_window,
	                                      :action => Gtk::FileChooser::Action::OPEN,
	                                      :buttons => [
	                                                   [Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL],
	                                                   [Gtk::Stock::OPEN, Gtk::ResponseType::ACCEPT]
	                                                  ]
	                                     )
	  
	  # Set up dialog options.
	  ruby_pi_folder = File.expand_path("..", File.dirname(__FILE__))
	  dialog.current_folder=(ruby_pi_folder)
	  
	  # Filter by file type.
	  yaml_filter = Gtk::FileFilter.new
	  yaml_filter.add_pattern("*.yml")
	  yaml_filter.name=("YAML")
	  
	  dialog.add_filter(yaml_filter)
	  
	  # Run the dialog.
	  if dialog.run == Gtk::ResponseType::ACCEPT
		loaded_pi_configuration = PIConfiguration.load_from_yaml(dialog.filename)
		$ruby_pi_main_gtk_window.pi_configuration = loaded_pi_configuration
	  end
	  
	  dialog.destroy
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
	  about_dialog = RubyPIAboutDialog.new
	  
	  about_dialog.run do |response|
		about_dialog.destroy
	  end
	end
	
	
	help_submenu.append(help_submenu_about)
	
	# Assign File -> to File
	help_menu.submenu = help_submenu
	
	
	self.show_all
	
	return self
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end