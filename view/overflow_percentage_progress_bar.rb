require 'gtk3'

class OverflowPercentageProgressBar < Gtk::ProgressBar
  def initialize(value = 0)
	# Call super with no params. (Meaning horizontal)
	super()
	
	# Set up Gtk::ProgressBar options.
	self.show_text = true
	
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
	# Round to the second digit and add a % sign.
	self.text = "#{@value.round(2)} %"
  end
end