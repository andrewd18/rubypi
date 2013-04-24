require_relative 'planetary_building.rb'
require_relative 'extractor_head.rb'

class Extractor < PlanetaryBuilding
  
  attr_accessor :extractor_heads
  
  POWERGRID_USAGE = 2600
  CPU_USAGE = 400
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 45000.00
  
  def initialize
	@base_powergrid_usage = POWERGRID_USAGE
	@base_cpu_usage = CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	
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
end
