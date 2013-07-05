require_relative 'planetary_building.rb'
require_relative 'unrestricted_storage.rb'
require_relative 'product.rb'

class CustomsOffice < PlanetaryBuilding
  
  include UnrestrictedStorage
  
  POWERGRID_USAGE = 0
  CPU_USAGE = 0
  POWERGRID_PROVIDED = 0
  CPU_PROVIDED = 0
  ISK_COST = 0.00
  STORAGE_VOLUME = 35000.0
  DEFAULT_TAX_RATE = 15
  MIN_TAX_RATE = 0
  MAX_TAX_RATE = 100
  
  def initialize
	@powergrid_usage = POWERGRID_USAGE
	@cpu_usage = CPU_USAGE
	@powergrid_provided = POWERGRID_PROVIDED
	@cpu_provided = CPU_PROVIDED
	@isk_cost = ISK_COST
	@tax_rate = DEFAULT_TAX_RATE
	
	return self
  end
  
  def name
	return "Customs Office"
  end
  
  def storage_volume
	return STORAGE_VOLUME
  end
  
  def tax_rate
	return @tax_rate
  end
  
  def tax_rate=(new_tax_rate)
	raise ArgumentError unless ((MIN_TAX_RATE..MAX_TAX_RATE).include?(new_tax_rate))
	
	@tax_rate = new_tax_rate
  end
  
  # Sending from launchpad to a customs office is a planetary export.
  def export_cost_with_tax(product_name, quantity)
	product_instance = Product.find_by_name(product_name)
	
	base_export_cost = product_instance.export_cost_for_quantity(quantity)
	
	# Divide by 100.0 to guarantee float.
	tax_rate_in_decimal = (@tax_rate / 100.0)
	
	return (base_export_cost * tax_rate_in_decimal)
  end
  
  # Sending from customs office to a launchpad is a planetary import.
  def import_cost_with_tax(product_name, quantity)
	product_instance = Product.find_by_name(product_name)
	
	base_import_cost = product_instance.import_cost_for_quantity(quantity)
	
	# Divide by 100.0 to guarantee float.
	tax_rate_in_decimal = (@tax_rate / 100.0)
	
	return (base_import_cost * tax_rate_in_decimal)
  end
end
