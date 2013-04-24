require 'gtk3'

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
	
	# Number of Heads Row
	number_of_heads_label = Gtk::Label.new("Number of Heads:")
	
	# Create the spin button.						# min, max, step
	@number_of_heads_spin_button = Gtk::SpinButton.new(0, 10, 1)
	@number_of_heads_spin_button.numeric = true
	
	
	
	# Extract Product Row
	extract_label = Gtk::Label.new("Extract:")
	
	# Populate the combobox backend model.
	@list_store_of_extractable_products = Gtk::ListStore.new(String)
	
	# Populate the list store with the products this extractor can extract.
	@extractor_model.accepted_product_names.each do |name|
	  new_row = @list_store_of_extractable_products.append
	  new_row.set_value(0, name)
	end
	
	@product_combo_box = Gtk::ComboBox.new(:model => @list_store_of_extractable_products)
	
	# Set up the view for the combo box column.
	combobox_renderer = Gtk::CellRendererText.new
	@product_combo_box.pack_start(combobox_renderer, true)
	@product_combo_box.add_attribute(combobox_renderer, "text", 0)
	
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
  
  # Called when the factory_model changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @number_of_heads_spin_button.value = @extractor_model.extractor_heads.count
	  
	  # Set the active product combo box iterator to the model's product name.
	  if (@extractor_model.product_name == nil)
		@product_combo_box.active_iter=(nil)
	  else
		# Find the iter that corresponds to the model's product.
		@list_store_of_extractable_products.each do |model, path, iter|
		  if (@extractor_model.product_name == iter.get_value(0))
			@product_combo_box.active_iter=(iter)
		  end
		end
	  end
	end
  end
  
  def commit_to_model
	# Stop observing so the values we want to set don't get overwritten on an #update.
	@extractor_model.delete_observer(self)
	
	@extractor_model.remove_all_heads
	
	num_heads_int = @number_of_heads_spin_button.value.to_i
	num_heads_int.times do
	  @extractor_model.add_extractor_head
	end
	
	# Ignore commit unless the user picked something legit.
	if (@product_combo_box.active_iter == nil)
	  return
	else
	  currently_selected_product_name = @product_combo_box.active_iter.get_value(0)
	  
	  # Find the product that corresponds to the active iterator.
	  @extractor_model.accepted_product_names.each do |name|
		if (name == currently_selected_product_name)
		  @extractor_model.product_name = name
		end
	  end
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