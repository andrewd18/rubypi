require_relative 'planetary_building.rb'
require_relative 'extractor_head.rb'

require_relative 'product.rb'

class Extractor < PlanetaryBuilding
  
  attr_accessor :extractor_heads
  attr_reader :product_name
  
  POWERGRID_USAGE = 2600
  CPU_USAGE = 400
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 45000.00
  
  EXTRACTS_P_LEVEL = 0
  
  def initialize(product_name = nil)
	@base_powergrid_usage = POWERGRID_USAGE
	@base_cpu_usage = CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	@product_name = product_name
	@extraction_time = nil
	
	@extractor_heads = Array.new
	
	return self
  end
  
  def name 
	return "Extractor"
  end
  
  def number_of_heads
	return @extractor_heads.count
  end
  
  def add_extractor_head
	if self.number_of_heads == 10
	  raise "Extractor already has 10 heads."
	else
	  extractor_head_instance = ExtractorHead.new
	  @extractor_heads << extractor_head_instance
	  
	  changed
	  notify_observers()
	  
	  return extractor_head_instance
	end
  end
  
  def remove_extractor_head(head)
	if (@extractor_heads.include?(head))
	  # Lean on array.delete.
	  @extractor_heads.delete(head)
	  
	  changed
	  notify_observers()
	else
	  raise "Extractor Head instance #{head} does not belong to this Extractor."
	end
  end
  
  def remove_all_heads
	@extractor_heads.clear
	
	changed
	notify_observers()
  end
  
  # Override powergrid_usage accessors.
  def powergrid_usage
	total = @base_powergrid_usage
	
	@extractor_heads.each do |head|
	  total = (total + head.powergrid_usage)
	end
	
	return total
  end
  
  def powergrid_usage=(value)
	@base_powergrid_usage = value
  end
  
  # Override cpu_usage accessors.
  def cpu_usage
	total = @base_cpu_usage
	
	@extractor_heads.each do |head|
	  total = (total + head.cpu_usage)
	end
	
	return total
  end
  
  def cpu_usage=(value)
	@base_cpu_usage = value
  end
  
  def accepted_product_names
	list_of_product_instances = Product.find_by_p_level(EXTRACTS_P_LEVEL)
	
	list_of_names = Array.new
	
	list_of_product_instances.each do |product|
	  list_of_names << product.name
	end
	
	return list_of_names
  end
  
  def product_name=(new_product_name)
	# Is it the same value?
	if (@product_name == new_product_name)
	  # Leave immediately but don't call our observers and don't error.
	  return @product_name
	
	# Is it nil?
	elsif (new_product_name == nil)
	  @product_name = nil
	  
	  # Notify our observers that we've changed.
	  changed
	  notify_observers
	  
	  return @product_name
	  
	# Okay, so it's not what we already have and it's not nil.
	# Is it a String?
	elsif (new_product_name.is_a?(String))
	  product_instance = Product.find_by_name(new_product_name)
	  
	  if (product_instance == nil)
		raise ArgumentError, "A Product for #{new_product_name} does not exist."
	  end
	  
	  # Product exists. Check it for P level.
	  if (product_instance.p_level != EXTRACTS_P_LEVEL)
		raise ArgumentError, "The #{new_product_name} Product is not a P-level #{EXTRACTS_P_LEVEL} Product."
	  end
	  
	  @product_name = new_product_name
	  
	  # Notify our observers that we've changed.
	  changed
	  notify_observers
	  
	# Is it something else?
	else
	  # Well, I don't want it so go away.
	  raise ArgumentError
	end
  end
  
  def product
	Product.find_by_name(@product_name)
  end
  
  def produces_product_name
	return @product_name
  end
  
  def extraction_time
	return @extraction_time
  end
  
  def extraction_time=(new_extraction_time)
	one_hour_up_to_twenty_five_hours = (1.0...25.0)
	twenty_five_hours_up_to_fifty_hours = (25.0...50.0)
	fifty_hours_up_to_one_hundred_hours = (50.0...100.0)
	one_hundred_hours_up_to_two_hundred_hours = (100.0...200.0)
	two_hundred_hours_up_to_and_including_max = (200.0..336.0)
	
	
	if (new_extraction_time < 1.0)
	  @extraction_time = 1.0
	  
	elsif (one_hour_up_to_twenty_five_hours.include?(new_extraction_time))
	  interval = 0.25
	  @extraction_time = nearest_higher_number_at_interval(new_extraction_time, interval)
	  
	elsif (twenty_five_hours_up_to_fifty_hours.include?(new_extraction_time))
	  interval = 0.5
	  @extraction_time = nearest_higher_number_at_interval(new_extraction_time, interval)
	  
	elsif (fifty_hours_up_to_one_hundred_hours.include?(new_extraction_time))
	  interval = 1.0
	  @extraction_time = nearest_higher_number_at_interval(new_extraction_time, interval)
	  
	elsif (one_hundred_hours_up_to_two_hundred_hours.include?(new_extraction_time))
	  interval = 2.0
	  @extraction_time = nearest_higher_number_at_interval(new_extraction_time, interval)
	  
	elsif (two_hundred_hours_up_to_and_including_max.include?(new_extraction_time))
	  interval = 4.0
	  @extraction_time = nearest_higher_number_at_interval(new_extraction_time, interval)
	  
	elsif (new_extraction_time > 336.0)
	  @extraction_time = 336.0
	end
	
	return @extraction_time
  end
  
  def extraction_time_in_minutes
	return (@extraction_time * 60.0)
  end
  
  def extraction_time_in_minutes=(new_extraction_time)
	new_extraction_time_in_hours = (new_extraction_time / 60.0)
	self.extraction_time=(new_extraction_time_in_hours)
  end
  
  def extraction_time_in_hours
	self.extraction_time
  end
  
  def extraction_time_in_hours=(new_extraction_time)
	self.extraction_time=(new_extraction_time)
  end
  
  def extraction_time_in_days
	return (@extraction_time / 24.0)
  end
  
  def extraction_time_in_days=(new_extraction_time)
	new_extraction_time_in_hours = (new_extraction_time * 24.0)
	self.extraction_time=(new_extraction_time_in_hours)
  end
  
  def cycle_time
	case @extraction_time
	  
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
	  return nil
	end
  end
  
  def cycle_time_in_minutes
	time_in_hours = self.cycle_time
	return (time_in_hours * 60)
  end
  
  def cycle_time_in_hours
	return self.cycle_time
  end
  
  def cycle_time_in_days
	time_in_hours = self.cycle_time
	return (time_in_hours / 24)
  end
  
  private
  
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
