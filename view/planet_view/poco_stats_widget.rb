require 'gtk3'

class PocoStatsWidget < Gtk::Frame
  
  def initialize(controller)
	super()
	
	@controller = controller
	
	# Create widgets.
	#
	# Standalone widgets.
	building_image = Gtk::Image.new(:file => "view/images/64x64/poco_icon.png")
	
	pct_storage_row = Gtk::Box.new(:horizontal)
	
	percent_storage_used_label = Gtk::Label.new("Pct Used:")
	
	@percent_storage_used_progress_bar = Gtk::ProgressBar.new
	@percent_storage_used_progress_bar.show_text = true # WORKAROUND - If you don't force this to true, text is never shown.
	
	pct_storage_row.pack_start(percent_storage_used_label, :expand => false)
	pct_storage_row.pack_start(@percent_storage_used_progress_bar, :expand => true)
	
	edit_poco_button = Gtk::Button.new(:label => "Edit Customs Office")
	edit_poco_button.signal_connect("clicked") do |widget, event|
	  @controller.edit_selected_building(@poco_model)
	end
	
	vbox = Gtk::Box.new(:vertical)
	vbox.pack_start(building_image, :expand => false)
	vbox.pack_start(pct_storage_row, :expand => false)
	vbox.pack_start(edit_poco_button, :expand => false)
	
	self.add(vbox)
	self.show_all
	
	return self
  end
  
  def planet_model=(new_planet_model)
	@planet_model = new_planet_model
	@poco_model = @planet_model.customs_office
	
	update_from_model
  end
  
  private
  
  def update_from_model
	@percent_storage_used_progress_bar.fraction = (@poco_model.pct_volume_used / 100.0)
	@percent_storage_used_progress_bar.text = "#{@poco_model.pct_volume_used} %"
  end
end