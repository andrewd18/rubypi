# A wrapper class to make working with Tables suck less.
# Caveat Emptor: This class prevents you from attaching widgets that span multiple rows or columns. It's a 1:1 ratio.
require 'gtk3'

class SimpleTable < Gtk::Table
  # Keep the standard initialize method.
  
  # Override attach
  def attach(widget, row, column)
	raise ArgumentError unless (row.is_a?(Numeric))
	raise ArgumentError unless (column.is_a?(Numeric))
	
	row_start = (row - 1)
	row_end = row
	
	column_start = (column - 1)
	column_end = column
	
	# Call the "real" attach with the determined options.
	super(widget, column_start, column_end, row_start, row_end)
  end
end