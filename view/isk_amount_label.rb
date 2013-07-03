require 'gtk3'

class IskAmountLabel < Gtk::Label
  def initialize(isk_value = 0)
	# Create a blank text superclass.
	super("")
	
	self.isk_value = isk_value
  end

  def isk_value=(new_isk_value)
	# If it's over 1 million, truncate
	# If it's under 1 million, show by default
	# Either way, hide the digits after the period.
	raise unless new_isk_value.is_a?(Numeric)
	
	@isk_value = new_isk_value
	
	self.update_text
  end
  
  def update_text
	# If it's over 1 million, divide by 1 million.
	# If it's under 1 million, show the full value.
	# Either way, hide the digits after the period.
	
	if (@isk_value >= 1000000.00)
	  # Divide by .00 value to ensure it's a float for best accuracy.
	  isk_value_in_m = (@isk_value / 1000000.00)
	  rounded_to_two_digits = isk_value_in_m.round(2)
	  
	  self.text = "#{rounded_to_two_digits} M ISK"
	else
	  integer_value = @isk_value.to_int
	  self.text = "#{integer_value} ISK"
	end
  end
end