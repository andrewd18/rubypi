require 'gtk3'

class SetExtractionTimeSlider < Gtk::Scale
  def initialize(extractor_model)
	@extractor_model = extractor_model
	
	super(:horizontal, @extractor_model.min_extraction_time, @extractor_model.max_extraction_time, self.calculate_step_interval_for_value(@extractor_model.extraction_time))
	
	self.digits=(2)
	
	self.signal_connect("value_changed") do
	  # Figure out what the new step interval should be for the given number.
	  new_step_interval = self.calculate_step_interval
	  new_page_interval = (new_step_interval * 10.0)
	  
	  # Figure out what the nearest acceptable number would be.
	  nearest_higher_value = nearest_higher_number_at_interval(self.value, new_step_interval)
	  
	  # If the user set the value to something not *.25, *.5, or *.0
	  # force the number to round up. This should re-call value-changed.
	  if (self.value != nearest_higher_value)
		self.value = nearest_higher_value
		
	  # The user set the value to something of *.25, *.5, or *.0.
	  else
		# Change the number of digits we show.
		if (new_step_interval == 0.25)
		  self.digits=(2)
		elsif (new_step_interval == 0.5)
		  self.digits=(1)
		else
		  self.digits=(0)
		end
		
		# Set the new increment values.
		self.set_increments(new_step_interval, new_page_interval)
	  end
	end
  end
  
  def calculate_step_interval
	self.calculate_step_interval_for_value(self.value)
  end
  
  def calculate_step_interval_for_value(dat_value)
	case dat_value
	  
	# If extraction time is > 60 minutes and < 25 hours
	# Cycle time should be 15 minutes.
	when (1.0...25.0)
	  return 0.25
	  
	# If extraction time is > 25 hours and < 50 hours
	# Cycle time should be 30 minutes.
	when (25.0...50.0)
	  return 0.5
	  
	# If extraction time is > 50 hours and < 100 hours
	# Cycle time should be 1 hour.
	when (50.0...100.0)
	  return 1.0
	  
	# If extraction time is > 100 hours and < 200 hours
	# Cycle time should be 2 hours.
	when (100.0...200.0)
	  return 2.0
	  
	# If extraction time is > 200 hours up to and including 336.0
	# Cycle time should be 4 hours.
	when (200.0..336.0)
	  return 4.0
	  
	else
	  return 1.0
	end
  end
  
  def nearest_higher_number_at_interval(starting_number, interval)
	# Return the next highest value that is divisible by interval.
	# e.g. - with an interval of 0.25, 1.666 turns into 1.75, 1.888 turns into 2.0.
	# 
	# Thank you to http://stackoverflow.com/questions/4874943/rounding-up-a-number-so-that-it-is-divisible-by-5
	
	number_divided_by_interval = (starting_number / interval)
	
	nearest_higher_integer = number_divided_by_interval.ceil
	
	return_value = (nearest_higher_integer * interval)
	
	return return_value
  end
end