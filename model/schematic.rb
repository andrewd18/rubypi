require_relative 'product.rb'

# A Schematic defines a series of build requirements for a given product.
class Schematic
  
  attr_reader :output_product
  attr_reader :output_quantity
  
  @@schematic_instances = Array.new
  
  def self.all
	return @@schematic_instances
  end
  
  def self.find_schematic_by_name(searched_name)
	@@schematic_instances.find {|instance| instance.name == searched_name}
  end
  
  def self.find_schematics_by_p_level(searched_p_level)
	@@schematic_instances.select {|instance| instance.p_level == searched_p_level}
  end
  
  def self.seed_all_schematics
	self.seed_p_one_schematics
	self.seed_p_two_schematics
	self.seed_p_three_schematics
	self.seed_p_four_schematics
	
	return true
  end
  
  def self.seed_p_one_schematics
	# P0 -> P1 Schematics.
	Schematic.new("Bacteria", 20, {"Microorganisms" => 3000})
	Schematic.new("Biofuels", 20, {"Carbon Compounds" => 3000})
	Schematic.new("Biomass", 20, {"Planktic Colonies" => 3000})
	Schematic.new("Chiral Structures", 20, {"Non-CS Crystals" => 3000})
	Schematic.new("Electrolytes", 20, {"Ionic Solutions" => 3000})
	Schematic.new("Industrial Fibers", 20, {"Autotrophs" => 3000})
	Schematic.new("Oxidizing Compound", 20, {"Reactive Gas" => 3000})
	Schematic.new("Oxygen", 20, {"Noble Gas" => 3000})
	Schematic.new("Plasmoids", 20, {"Suspended Plasma" => 3000})
	Schematic.new("Precious Metals", 20, {"Noble Metals" => 3000})
	Schematic.new("Proteins", 20, {"Complex Organisms" => 3000})
	Schematic.new("Reactive Metals", 20, {"Base Metals" => 3000})
	Schematic.new("Silicon", 20, {"Felsic Magma" => 3000})
	Schematic.new("Toxic Metals", 20, {"Heavy Metals" => 3000})
	Schematic.new("Water", 20, {"Aqueous Liquids" => 3000})
	
	return true
  end
  
  def self.seed_p_two_schematics
	# P1 -> P2 schematics.
	Schematic.new("Biocells", 5, {"Biofuels" => 40, "Precious Metals" => 40})
	Schematic.new("Construction Blocks", 5, {"Reactive Metals" => 40, "Toxic Metals" => 40})
	Schematic.new("Consumer Electronics", 5, {"Toxic Metals" => 40, "Chiral Structures" => 40})
	Schematic.new("Coolant", 5, {"Electrolytes" => 40, "Water" => 40})
	Schematic.new("Enriched Uranium", 5, {"Precious Metals" => 40, "Toxic Metals" => 40})
	Schematic.new("Fertilizer", 5, {"Bacteria" => 40, "Proteins" => 40})
	Schematic.new("Genetically Enhanced Livestock", 5, {"Proteins" => 40, "Biomass" => 40})
	Schematic.new("Livestock", 5, {"Proteins" => 40, "Biofuels" => 40})
	Schematic.new("Mechanical Parts", 5, {"Reactive Metals" => 40, "Precious Metals" => 40})
	Schematic.new("Microfiber Shielding", 5, {"Industrial Fibers" => 40, "Silicon" => 40})
	Schematic.new("Miniature Electronics", 5, {"Chiral Structures" => 40, "Silicon" => 40})
	Schematic.new("Nanites", 5, {"Bacteria" => 40, "Reactive Metals" => 40})
	Schematic.new("Oxides", 5, {"Oxidizing Compound" => 40, "Oxygen" => 40})
	Schematic.new("Polyaramids", 5, {"Oxidizing Compound" => 40, "Industrial Fibers" => 40})
	Schematic.new("Polytextiles", 5, {"Biofuels" => 40, "Industrial Fibers" => 40})
	Schematic.new("Rocket Fuel", 5, {"Plasmoids" => 40, "Electrolytes" => 40})
	Schematic.new("Silicate Glass", 5, {"Oxidizing Compound" => 40, "Silicon" => 40})
	Schematic.new("Superconductors", 5, {"Plasmoids" => 40, "Water" => 40})
	Schematic.new("Supertensile Plastics", 5, {"Oxygen" => 40, "Biomass" => 40})
	Schematic.new("Synthetic Oil", 5, {"Electrolytes" => 40, "Oxygen" => 40})
	Schematic.new("Test Cultures", 5, {"Bacteria" => 40, "Water" => 40})
	Schematic.new("Transmitter", 5, {"Plasmoids" => 40, "Chiral Structures" => 40})
	Schematic.new("Viral Agent", 5, {"Bacteria" => 40, "Biomass" => 40})
	Schematic.new("Water-Cooled CPU", 5, {"Reactive Metals" => 40, "Water" => 40})
	
	return true
  end
  
  def self.seed_p_three_schematics
	# P2 -> P3 schematics.
	Schematic.new("Biotech Research Reports", 3, {"Nanites" => 10, "Livestock" => 10, "Construction Blocks" => 10})
	Schematic.new("Camera Drones", 3, {"Silicate Glass" => 10, "Rocket Fuel" => 10})
	Schematic.new("Condensates", 3, {"Oxides" => 10, "Coolant" => 10})
	Schematic.new("Cryoprotectant Solution", 3, {"Test Cultures" => 10, "Synthetic Oil" => 10, "Fertilizer" => 10})
	Schematic.new("Data Chips", 3, {"Supertensile Plastics" => 10, "Microfiber Shielding" => 10})
	Schematic.new("Gel-Matrix Biopaste", 3, {"Oxides" => 10, "Biocells" => 10, "Superconductors" => 10})
	Schematic.new("Guidance Systems", 3, {"Water-Cooled CPU" => 10, "Transmitter" => 10})
	Schematic.new("Hazmat Detection Systems", 3, {"Polytextiles" => 10, "Viral Agent" => 10, "Transmitter" => 10})
	Schematic.new("Hermetic Membranes", 3, {"Polyaramids" => 10, "Genetically Enhanced Livestock" => 10})
	Schematic.new("High-Tech Transmitters", 3, {"Polyaramids" => 10, "Transmitter" => 10})
	Schematic.new("Industrial Explosives", 3, {"Fertilizer" => 10, "Polytextiles" => 10})
	Schematic.new("Neocoms", 3, {"Biocells" => 10, "Silicate Glass" => 10})
	Schematic.new("Nuclear Reactors", 3, {"Enriched Uranium" => 10, "Microfiber Shielding" => 10})
	Schematic.new("Planetary Vehicles", 3, {"Supertensile Plastics" => 10, "Mechanical Parts" => 10, "Miniature Electronics" => 10})
	Schematic.new("Robotics", 3, {"Mechanical Parts" => 10, "Consumer Electronics" => 10})
	Schematic.new("Smartfab Units", 3, {"Construction Blocks" => 10, "Miniature Electronics" => 10})
	Schematic.new("Supercomputers", 3, {"Water-Cooled CPU" => 10, "Coolant" => 10, "Consumer Electronics" => 10})
	Schematic.new("Synthetic Synapses", 3, {"Supertensile Plastics" => 10, "Test Cultures" => 10})
	Schematic.new("Transcranial Microcontrollers", 3, {"Biocells" => 10, "Nanites" => 10})
	Schematic.new("Ukomi Superconductors", 3, {"Synthetic Oil" => 10, "Superconductors" => 10})
	Schematic.new("Vaccines", 3, {"Livestock" => 10, "Viral Agent" => 10})
	
	return true
  end
  
  def self.seed_p_four_schematics
	# P3 -> P4 schematics.
	Schematic.new("Broadcast Node", 3, {"Neocoms" => 6, "Data Chips" => 6, "High-Tech Transmitters" => 6})
	Schematic.new("Integrity Response Drones", 3, {"Gel-Matrix Biopaste" => 6, "Hazmat Detection Systems" => 6, "Planetary Vehicles" => 6})
	Schematic.new("Nano-Factory", 3, {"Industrial Explosives" => 6, "Reactive Metals" => 40, "Ukomi Superconductors" => 6})
	Schematic.new("Organic Mortar Applicators", 3, {"Condensates" => 6, "Bacteria" => 40, "Robotics" => 6})
	Schematic.new("Recursive Computing Module", 3, {"Synthetic Synapses" => 6, "Guidance Systems" => 6, "Transcranial Microcontrollers" => 6})
	Schematic.new("Self-Harmonizing Power Core", 3, {"Camera Drones" => 6, "Nuclear Reactors" => 6, "Hermetic Membranes" => 6})
	Schematic.new("Sterile Conduits", 3, {"Smartfab Units" => 6, "Water" => 40, "Vaccines" => 6})
	Schematic.new("Wetware Mainframe", 3, {"Supercomputers" => 6, "Biotech Research Reports" => 6, "Cryoprotectant Solution" => 6})
	
	return true
  end
  
  def initialize(output_product = nil, output_quantity = nil, inputs_hash = {})
	@output_product = output_product
	@output_quantity = output_quantity
	@inputs_hash = inputs_hash
	
	@@schematic_instances << self
	
	return self
  end
  
  def name
	return @output_product.name
  end
  
  def p_level
	return @output_product.p_level
  end
  
  def add_input(product_name_to_quantity_hash)
	raise ArgumentError, "Argument is not a Hash." unless product_name_to_quantity_hash.is_a?(Hash)
	
	product_name_to_quantity_hash.each_pair do |key, value|
	  raise ArgumentError, "#{key} is not a Product." unless key.is_a?(Product)
	  raise ArgumentError, "#{value} is not a Numeric." unless value.is_a?(Numeric)
	  
	  # Error if we already have this input.
	  raise ArgumentError, "#{key} is already an input." if @inputs_hash.has_key?(key)
	end
	
	# Input params are ok. Merge in.
	@inputs_hash.merge!(product_name_to_quantity_hash)
	
	return @inputs_hash
  end
  
  def remove_input(product_instance)
	@inputs_hash.delete(product_instance)
  end
  
  def inputs
	return @inputs_hash
  end
end
