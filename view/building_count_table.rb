class BuildingCountTable < Gtk::Table
  def initialize(planet_model)
	super(2, 2)
	
	# Hook up model data.
	@planet_model = planet_model
	@planet_model.add_observer(self)
	
	# Building stats box like FIDS in Endless Space.
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	extractor_cell = Gtk::Box.new(:horizontal)
	factory_cell = Gtk::Box.new(:horizontal)
	storage_cell = Gtk::Box.new(:horizontal)
	launchpad_cell = Gtk::Box.new(:horizontal)
	
	extractor_icon = Gtk::Image.new(:file => "view/images/minimalistic_extractor_icon.png")
	@num_extractors_label = Gtk::Label.new("#{@planet_model.num_extractors}")
	
	factory_icon = Gtk::Image.new(:file => "view/images/minimalistic_factory_icon.png")
	@num_factories_label = Gtk::Label.new("#{@planet_model.num_factories}")
	
	storage_icon = Gtk::Image.new(:file => "view/images/minimalistic_storage_facility_icon.png")
	@num_storages_label = Gtk::Label.new("#{@planet_model.num_storages}")
	
	launchpad_icon = Gtk::Image.new(:file => "view/images/minimalistic_launchpad_icon.png")
	@num_launchpads_label = Gtk::Label.new("#{@planet_model.num_launchpads}")
	
	
	extractor_cell.pack_start(extractor_icon)
	extractor_cell.pack_start(@num_extractors_label)
	
	factory_cell.pack_start(factory_icon)
	factory_cell.pack_start(@num_factories_label)
	
	storage_cell.pack_start(storage_icon)
	storage_cell.pack_start(@num_storages_label)
	
	launchpad_cell.pack_start(launchpad_icon)
	launchpad_cell.pack_start(@num_launchpads_label)
	
	# First row.
	self.attach(extractor_cell, 0, 1, 0, 1)
	self.attach(factory_cell, 1, 2, 0, 1)
	
	# Second row.
	self.attach(storage_cell, 0, 1, 1, 2)
	self.attach(launchpad_cell, 1, 2, 1, 2)
	
	return self
  end
  
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @num_extractors_label.text = "#{@planet_model.num_extractors}"
	  @num_factories_label.text = "#{@planet_model.num_factories}"
	  @num_storages_label.text = "#{@planet_model.num_storages}"
	  @num_launchpads_label.text = "#{@planet_model.num_launchpads}"
	end
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	@planet_model.delete_observer(self)
	
	super
  end
end