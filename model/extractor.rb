require_relative 'planetary_building.rb'

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
  
  def add_extractor_head(head)
	if @extractor_heads.count == 8
	  # TODO
	  # Error and shit.
	else
	  @extractor_heads << head
	  changed
	  notify_observers()
	end
	
  end
  
  def remove_extractor_head(head)
	# TODO
	# Lean on Array.remove?
	#
	#changed
	#notify_observers()
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
