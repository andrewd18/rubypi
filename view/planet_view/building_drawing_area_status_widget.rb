class BuildingDrawingAreaStatusWidget < Gtk::Box
  def initialize(drawing_area)
	super(:horizontal)
	
	@drawing_area = drawing_area
	
	# Observe drawing area.
	@drawing_area.add_observer(self)
	
	@label = Gtk::Label.new("")
	
	self.pack_start(@label, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def update
	@label.text = "#{@drawing_area.status_message}"
  end
  
  def destroy
	@drawing_area.delete_observer(self)
	
	super
  end
end