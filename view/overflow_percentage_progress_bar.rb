require 'gtk3'

class OverflowPercentageProgressBar < Gtk::ProgressBar
  def initialize(value = 0, round_to_digits = nil)
	# Call super with no params. (Meaning horizontal)
	super()
	
	# Set up Gtk::ProgressBar options.
	self.show_text = true
	
	if (round_to_digits != nil)
	  raise unless round_to_digits.is_a?(Numeric)
	  
	  @round_to_digits = round_to_digits
	end
	
	# Finally input the value.
	self.value = value
	
	return self
  end
  
  def value
	return @value
  end
  
  def value=(new_value)
	raise ArgumentError unless new_value.is_a?(Numeric)
	
	@value = new_value
	
	# Update the fill width.
	# Handle > 100% gracefully.
	if (@value > 100)
	  self.fraction = 1.0
	elsif ((0..100).include? (@value))
	  self.fraction = (@value / 100.0)
	else
	  self.fraction = 0.0
	end
	
	# Update the text overlaying the fill width.
	# Add a % sign.
	if (@round_to_digits != nil)
	  self.text = "#{@value.round(@round_to_digits)} %"
	else
	  self.text = "#{@value} %"
	end
  end
end