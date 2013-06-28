# A wrapper class to make working with Tables suck less.
# Caveat Emptor: This class prevents you from attaching widgets that span multiple rows or columns. It's a 1:1 ratio.
require 'gtk3'

class SimpleTable < Gtk::Table
  # Keep the standard initialize method.
  
  # Override attach
  def attach(widget, row, column, expand_width = true, fill_width = true, expand_height = true, fill_height = true)
	raise ArgumentError unless (row.is_a?(Numeric))
	raise ArgumentError unless (column.is_a?(Numeric))
	
	row_start = (row - 1)
	row_end = row
	
	column_start = (column - 1)
	column_end = column
	
	
	if ((expand_width == true) and
	    (fill_width == true))
	  
	  width_options = [Gtk::AttachOptions::EXPAND, Gtk::AttachOptions::FILL]
	  
	elsif ((expand_width == true) and
	       (fill_width == false))
	  
	  width_options = [Gtk::AttachOptions::EXPAND]
	  
	else
	  
	  width_options = []
	end
	
	
	if ((expand_height == true) and
	    (fill_height == true))
	  
	  height_options = [Gtk::AttachOptions::EXPAND, Gtk::AttachOptions::FILL]
	  
	elsif ((expand_height == true) and
	       (expand_width == false))
	  
	  height_options = [Gtk::AttachOptions::EXPAND]
	  
	else
	  
	  height_options = []
	end
	
	
	
	# Call the "real" attach with the determined options.
	super(widget, column_start, column_end, row_start, row_end, width_options, height_options)
  end
end