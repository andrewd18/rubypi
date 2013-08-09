require 'gtk3'

require_relative 'building_view_widget.rb'

class PocoStatsWidget < Gtk::Frame
  
  def initialize(poco_model)
	super()
	
	# Hook up model data.
	@poco_model = poco_model
	
	# Create widgets.
	#
	# Standalone widgets.
	building_image = Gtk::Image.new(:file => "view/images/64x64/poco_icon.png")
	
	pct_storage_row = Gtk::Box.new(:horizontal)
	
	percent_storage_used_label = Gtk::Label.new("Pct Used:")
	
	percent_storage_used_progress_bar = Gtk::ProgressBar.new
	percent_storage_used_progress_bar.fraction = (@poco_model.pct_volume_used / 100.0)
	percent_storage_used_progress_bar.text = "#{@poco_model.pct_volume_used} %"
	percent_storage_used_progress_bar.show_text = true # WORKAROUND - If you don't force this to true, text is never shown.
	
	pct_storage_row.pack_start(percent_storage_used_label, :expand => false)
	pct_storage_row.pack_start(percent_storage_used_progress_bar, :expand => true)
	
	edit_poco_button = Gtk::Button.new(:label => "Edit Customs Office")
	edit_poco_button.signal_connect("clicked") do |widget, event|
	  # Change main widget to edit poco window
	  edit_poco
	end
	
	vbox = Gtk::Box.new(:vertical)
	vbox.pack_start(building_image, :expand => false)
	vbox.pack_start(pct_storage_row, :expand => false)
	vbox.pack_start(edit_poco_button, :expand => false)
	
	self.add(vbox)
	self.show_all
	
	return self
  end
  
  private
  
  def edit_poco
	$ruby_pi_main_gtk_window.change_main_widget(BuildingViewWidget.new(@poco_model))
  end
end