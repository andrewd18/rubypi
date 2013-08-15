class SaveToYamlDialog < Gtk::FileChooserDialog
  def initialize(parent_window)
	super(:title => "Save File",
		  :parent => parent_window,
		  :action => Gtk::FileChooser::Action::SAVE,
		  :buttons => [
						[Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL],
						[Gtk::Stock::SAVE, Gtk::ResponseType::ACCEPT]
					  ]
		  )
	
	
	# Set up options.
	ruby_pi_folder = File.expand_path("../..", File.dirname(__FILE__))
	self.current_folder=(ruby_pi_folder)
	self.do_overwrite_confirmation = true
	
	# Filter out anything but YAML files.
	yaml_filter = Gtk::FileFilter.new
	yaml_filter.add_pattern("*.yml")
	yaml_filter.name=("YAML")
	
	self.add_filter(yaml_filter)
  end
end