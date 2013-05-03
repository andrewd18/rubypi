require 'gtk3'
require_relative '../model/extractor.rb'

class SetExtractionTimeSlider < Gtk::Scale
  def initialize(extractor_model)
	
	model_cycle_time = Extractor.cycle_time_given_extraction_time(extractor_model.extraction_time)
	if (model_cycle_time == nil)
	  # The model has never been configured.
	  # Set it to the min cycle value.
	  model_cycle_time = Extractor.cycle_time_given_extraction_time(Extractor.min_extraction_time)
	end
	
	super(:horizontal, Extractor.min_extraction_time, Extractor.max_extraction_time, model_cycle_time)
	
	self.digits=(2)
	
	self.signal_connect("value_changed") do
	  # Figure out what the new step interval should be for the given number.
	  new_step_interval = Extractor.cycle_time_given_extraction_time(self.value)
	  new_page_interval = (new_step_interval * 10.0)
	  
	  # Figure out what the nearest acceptable number would be.
	  nearest_higher_value = Extractor.nearest_valid_extraction_time(self.value)
	  
	  # If the user set the value to something not *.25, *.5, or *.0
	  # force the number to round up. This should re-emit the value_changed signal, thus re-running this function.
	  if (self.value != nearest_higher_value)
		self.value = nearest_higher_value
		
	  # The user set the value to something of *.25, *.5, or *.0.
	  else
		# Set the new increment values.
		self.set_increments(new_step_interval, new_page_interval)
	  end
	end
  end
end