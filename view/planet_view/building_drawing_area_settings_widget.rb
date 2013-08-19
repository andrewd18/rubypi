class BuildingDrawingAreaSettingsWidget < Gtk::Box
  def initialize(drawing_area)
	super(:horizontal)
	
	@drawing_area = drawing_area
	
	show_buildings_label = Gtk::Label.new("Show Buildings:")
	@show_buildings_button = Gtk::Switch.new
	@show_buildings_button.active = @drawing_area.show_buildings
	@show_buildings_button.signal_connect("notify::active") do |butan|
	  @drawing_area.show_buildings = butan.active?
	  @drawing_area.queue_draw
	end
	
	show_links_label = Gtk::Label.new("Show Links:")
	@show_links_button = Gtk::Switch.new
	@show_links_button.active = @drawing_area.show_links
	@show_links_button.signal_connect("notify::active") do |butan|
	  @drawing_area.show_links = butan.active?
	  @drawing_area.queue_draw
	end
	
	# Pack right to left.
	self.pack_end(@show_links_button, :expand => false)
	self.pack_end(show_links_label, :expand => false)
	self.pack_end(@show_buildings_button, :expand => false)
	self.pack_end(show_buildings_label, :expand => false)
	
	
	self.show_all
	
	return self
  end
end