require 'gtk3'

# This widget provides all the options necessary to edit an Extractor.
class EditExtractorWidget < Gtk::Box
  
  attr_accessor :building_model
  
  def initialize(building_model)
	super(:vertical)
	
	# Hook up model data.
	@building_model = building_model
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	# Add planet building stats widgets in a nice grid.
	extractor_stats_table = Gtk::Table.new(7, 2)
	
	# Number of Heads Row
	number_of_heads_label = Gtk::Label.new("Number of Heads:")
	
	# Create the spin button.						# min, max, step
	@number_of_heads_spin_button = Gtk::SpinButton.new(0, 10, 1)
	@number_of_heads_spin_button.numeric = true
	
	
	
	# Extract Product Row
	extract_label = Gtk::Label.new("Extract:")
	
	@product_combo_box = Gtk::ComboBoxText.new
	@building_model.accepted_product_names.each do |name|
	  @product_combo_box.append_text(name)
	end
	
	# Set the active iterater from the model data.
	# Since #update does this, call #update.
	update
	
	extractor_stats_table.attach(extract_label, 0, 1, 0, 1)
	extractor_stats_table.attach(@product_combo_box, 1, 2, 0, 1)
	
	extractor_stats_table.attach(number_of_heads_label, 0, 1, 1, 2)
	extractor_stats_table.attach(@number_of_heads_spin_button, 1, 2, 1, 2)
	
	self.pack_start(extractor_stats_table, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def start_observing_model
	@building_model.add_observer(self)
  end
  
  def stop_observing_model
	@building_model.delete_observer(self)
  end
  
  # Called when the factory_model changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @number_of_heads_spin_button.value = @building_model.extractor_heads.count
	  
	  # Set the active product combo box iterator to the model's product name.
	  if (@building_model.product_name == nil)
		@product_combo_box.active_iter=(nil)
	  else
		# Find the iter that corresponds to the model's product.
		@product_combo_box.model.each do |model, path, iter|
		  if (@building_model.product_name == iter.get_value(0))
			@product_combo_box.active_iter=(iter)
		  end
		end
	  end
	end
  end
  
  def commit_to_model
	self.stop_observing_model
	
	@building_model.remove_all_heads
	
	num_heads_int = @number_of_heads_spin_button.value.to_i
	num_heads_int.times do
	  @building_model.add_extractor_head
	end
	
	# Ignore commit unless the user picked something legit.
	if (@product_combo_box.active_iter == nil)
	  return
	else
	  currently_selected_product_name = @product_combo_box.active_iter.get_value(0)
	  
	  # Find the product that corresponds to the active iterator.
	  @building_model.accepted_product_names.each do |name|
		if (name == currently_selected_product_name)
		  @building_model.product_name = name
		end
	  end
	end
	
	# Start observing again.
	self.start_observing_model
  end
  
  def destroy
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end