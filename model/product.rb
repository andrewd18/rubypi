class Product
  attr_reader :name
  attr_reader :p_level
  
  P_LEVEL_TO_VOLUME = {0 => 0.01,
                       1 => 0.38,
                       2 => 1.50,
                       3 => 6.00,
                       4 => 100 }
  
  P_LEVEL_TO_IMPORT_EXPORT_BASE_COST = {0 => 5.00,
                                        1 => 500.00,
                                        2 => 9000.00,
                                        3 => 70000.00,
                                        4 => 1350000.00}
  
  @@product_instances = Array.new
  
  def self.all
	return @@product_instances
  end
  
  def self.find_by_name(searched_name)
	@@product_instances.select {|instance| instance.name == searched_name}
  end
  
  def self.find_by_p_level(searched_p_level)
	@@product_instances.select {|instance| instance.p_level == searched_p_level}
  end
  
  def self.seed_all_products
	self.seed_p_zero_products
	self.seed_p_one_products
	self.seed_p_two_products
	self.seed_p_three_products
	self.seed_p_four_products
	
	return true
  end
  
  def self.seed_p_zero_products
	# P0 Products.
	p_zero_products = ["Aqueous Liquids",
					   "Autotrophs",
					   "Base Metals",
					   "Carbon Compounds",
					   "Complex Organisms",
					   "Felsic Magma",
					   "Heavy Metals",
					   "Ionic Solutions",
					   "Microorganisms",
					   "Noble Gas",
					   "Noble Metals",
					   "Non-CS Crystals",
					   "Planktic Colonies",
					   "Reactive Gas",
					   "Suspended Plasma"]

	p_zero_products.each do |product_name|
	  Product.new(product_name, 0)
	end
	
	return true
  end
  
  def self.seed_p_one_products
	# P1 Products
	p_one_products = ["Bacteria",
					  "Biofuels",
					  "Biomass",
					  "Chiral Structures",
					  "Electrolytes",
					  "Industrial Fibers",
					  "Oxidizing Compound",
					  "Oxygen",
					  "Plasmoids",
					  "Precious Metals",
					  "Proteins",
					  "Reactive Metals",
					  "Silicon",
					  "Toxic Metals",
					  "Water"]

	p_one_products.each do |product_name|
	  Product.new(product_name, 1)
	end
	
	return true
  end
  
  def self.seed_p_two_products
	# P2 Products
	p_two_products = ["Biocells",
					  "Construction Blocks",
					  "Consumer Electronics",
					  "Coolant",
					  "Enriched Uranium",
					  "Fertilizer",
					  "Genetically Enhanced Livestock",
					  "Livestock",
					  "Mechanical Parts",
					  "Microfiber Shielding",
					  "Miniature Electronics",
					  "Nanites",
					  "Oxides",
					  "Polyaramids",
					  "Polytextiles",
					  "Rocket Fuel",
					  "Silicate Glass",
					  "Superconductors",
					  "Supertensile Plastics",
					  "Synthetic Oil",
					  "Test Cultures",
					  "Transmitter",
					  "Viral Agent",
					  "Water-Cooled CPU"]

	p_two_products.each do |product_name|
	  Product.new(product_name, 2)
	end
	
	return true
  end
  
  def self.seed_p_three_products
	# P3 Products
	p_three_products = ["Biotech Research Reports",
						"Camera Drones",
						"Condensates",
						"Cryoprotectant Solution",
						"Data Chips",
						"Gel-Matrix Biopaste",
						"Guidance Systems",
						"Hazmat Detection Systems",
						"Hermetic Membranes",
						"High-Tech Transmitters",
						"Industrial Explosives",
						"Neocoms",
						"Nuclear Reactors",
						"Planetary Vehicles",
						"Robotics",
						"Smartfab Units",
						"Supercomputers",
						"Synthetic Synapses",
						"Transcranial Microcontrollers",
						"Ukomi Superconductors",
						"Vaccines"]

	p_three_products.each do |product_name|
	  Product.new(product_name, 3)
	end
	
	return true
  end
  
  def self.seed_p_four_products
	# P4 Products
	p_four_products = ["Broadcast Node",
					  "Integrity Response Drones",
					  "Nano-Factory",
					  "Organic Mortar Applicators",
					  "Recursive Computing Module",
					  "Self-Harmonizing Power Core",
					  "Sterile Conduits",
					  "Wetware Mainframe"]

	p_four_products.each do |product_name|
	  Product.new(product_name, 4)
	end
	
	return true
  end
  
  def initialize(name, p_level)
	array_of_instances_with_same_name = self.class.find_by_name(name)
	raise "A product with the name \"#{name}\" already exists." unless array_of_instances_with_same_name.empty?
	
	@name = name
	@p_level = p_level
	
	@@product_instances << self
	
	return self
  end
  
  def set_p_level(level)
	if (level.between?(0, 4))
	  # Ok, it's a valid level.
	  # Let's make sure we're not setting something we already have.
	  if (level == @p_level)
		# No change in the value.
		return
	  end
	  
	  @p_level = level
	else
	  # Invalid level passed.
	  raise ArgumentError, "Passed in level must be between 0 and 5."
	end
  end
  
  def volume
	return P_LEVEL_TO_VOLUME[@p_level]
  end
  
  def base_import_export_cost
	return P_LEVEL_TO_IMPORT_EXPORT_BASE_COST[@p_level]
  end
  
  def base_import_export_cost_for_quantity(quantity)
	return (P_LEVEL_TO_IMPORT_EXPORT_BASE_COST[@p_level] * quantity)
  end
end