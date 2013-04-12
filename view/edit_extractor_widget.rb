
require 'gtk3'
require_relative '../model/extractor_head.rb'


# This widget provides all the options necessary to edit an Extractor.
class EditExtractorWidget < Gtk::Box
  def initialize(extractor_model)
	super(:vertical)
	
	# Hook up model data.
	@extractor_model = extractor_model
	@extractor_model.add_observer(self)
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	# Add planet building stats widgets in a nice grid.
	extractor_stats_table = Gtk::Table.new(7, 2)
	
	# Schematic Row
	number_of_heads_label = Gtk::Label.new("Number of Heads:")
	
	# Create the spin button.						# min, max, step
	@number_of_heads_spin_button = Gtk::SpinButton.new(0, 10, 1)
	@number_of_heads_spin_button.numeric = true
	
	
	# Set the active iterater from the model data.
	# Since #update does this, call #update.
	update
	
	
	extractor_stats_table.attach(number_of_heads_label, 0, 1, 0, 1)
	extractor_stats_table.attach(@number_of_heads_spin_button, 1, 2, 0, 1)
	
	self.pack_start(extractor_stats_table, :expand => false)
	
	self.show_all
	
	return self
  end
  
  # Called when the factory_model changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @number_of_heads_spin_button.value = @extractor_model.extractor_heads.count
	end
  end
  
  def commit_to_model
	# Stop observing so the values we want to set don't get overwritten on an #update.
	@extractor_model.delete_observer(self)
	
	@extractor_model.remove_all_heads
	
	num_heads_int = @number_of_heads_spin_button.value.to_i
	
	num_heads_int.times do
	  @extractor_model.add_extractor_head(ExtractorHead.new)
	end
	
	# Start observing again.
	@extractor_model.add_observer(self)
  end
  
  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	@extractor_model.delete_observer(self)
	
	super
  end
end