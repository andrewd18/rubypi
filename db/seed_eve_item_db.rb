require_relative 'connect_to_eve_item_db.rb'

require_relative '../model/product.rb'
require_relative '../model/schematic.rb'

# P0 Commodities.
aqueous_liquids = Product.find_or_create(:name => "Aqueous Liquids"){|product| product.p_level = 0}
autotrophs = Product.find_or_create(:name => "Autotrophs"){|product| product.p_level = 0}
base_metals = Product.find_or_create(:name => "Base Metals"){|product| product.p_level = 0}
carbon_compounds = Product.find_or_create(:name => "Carbon Compounds"){|product| product.p_level = 0}
complex_organisms = Product.find_or_create(:name => "Complex Organisms"){|product| product.p_level = 0}
felsic_magma = Product.find_or_create(:name => "Felsic Magma"){|product| product.p_level = 0}
heavy_metals = Product.find_or_create(:name => "Heavy Metals"){|product| product.p_level = 0}
ionic_solutions = Product.find_or_create(:name => "Ionic Solutions"){|product| product.p_level = 0}
microorganisms = Product.find_or_create(:name => "Microorganisms"){|product| product.p_level = 0}
noble_gas = Product.find_or_create(:name => "Noble Gas"){|product| product.p_level = 0}
noble_metals = Product.find_or_create(:name => "Noble Metals"){|product| product.p_level = 0}
non_cs_crystals = Product.find_or_create(:name => "Non-CS Crystals"){|product| product.p_level = 0}
planktic_colonies = Product.find_or_create(:name => "Planktic Colonies"){|product| product.p_level = 0}
reactive_gas = Product.find_or_create(:name => "Reactive Gas"){|product| product.p_level = 0}
suspended_plasma = Product.find_or_create(:name => "Suspended Plasma"){|product| product.p_level = 0}

# P1 Commodities
bacteria = Product.find_or_create(:name => "Bacteria"){|product| product.p_level = 1}
biofuels = Product.find_or_create(:name => "Biofuels"){|product| product.p_level = 1}
biomass = Product.find_or_create(:name => "Biomass"){|product| product.p_level = 1}
chiral_structures = Product.find_or_create(:name => "Chiral Structures"){|product| product.p_level = 1}
electrolytes = Product.find_or_create(:name => "Electrolytes"){|product| product.p_level = 1}
industrial_fibers = Product.find_or_create(:name => "Industrial Fibers"){|product| product.p_level = 1}
oxidizing_compound = Product.find_or_create(:name => "Oxidizing Compound"){|product| product.p_level = 1}
oxygen = Product.find_or_create(:name => "Oxygen"){|product| product.p_level = 1}
plasmoids = Product.find_or_create(:name => "Plasmoids"){|product| product.p_level = 1}
precious_metals = Product.find_or_create(:name => "Precious Metals"){|product| product.p_level = 1}
proteins = Product.find_or_create(:name => "Proteins"){|product| product.p_level = 1}
reactive_metals = Product.find_or_create(:name => "Reactive Metals"){|product| product.p_level = 1}
silicon = Product.find_or_create(:name => "Silicon"){|product| product.p_level = 1}
toxic_metals = Product.find_or_create(:name => "Toxic Metals"){|product| product.p_level = 1}
water = Product.find_or_create(:name => "Water"){|product| product.p_level = 1}

# P2 Commodities
biocells = Product.find_or_create(:name => "Biocells"){|product| product.p_level = 2}
construction_blocks = Product.find_or_create(:name => "Construction Blocks"){|product| product.p_level = 2}
consumer_electronics = Product.find_or_create(:name => "Consumer Electronics"){|product| product.p_level = 2}
coolant = Product.find_or_create(:name => "Coolant"){|product| product.p_level = 2}
enriched_uranium = Product.find_or_create(:name => "Enriched Uranium"){|product| product.p_level = 2}
fertilizer = Product.find_or_create(:name => "Fertilizer"){|product| product.p_level = 2}
genetically_enhanced_livestock = Product.find_or_create(:name => "Genetically Enhanced Livestock"){|product| product.p_level = 2}
livestock = Product.find_or_create(:name => "Livestock"){|product| product.p_level = 2}
mechanical_parts = Product.find_or_create(:name => "Mechanical Parts"){|product| product.p_level = 2}
microfiber_shielding = Product.find_or_create(:name => "Microfiber Shielding"){|product| product.p_level = 2}
miniature_electronics = Product.find_or_create(:name => "Miniature Electronics"){|product| product.p_level = 2}
nanites = Product.find_or_create(:name => "Nanites"){|product| product.p_level = 2}
oxides = Product.find_or_create(:name => "Oxides"){|product| product.p_level = 2}
polyaramids = Product.find_or_create(:name => "Polyaramids"){|product| product.p_level = 2}
polytextiles = Product.find_or_create(:name => "Polytextiles"){|product| product.p_level = 2}
rocket_fuel = Product.find_or_create(:name => "Rocket Fuel"){|product| product.p_level = 2}
silicate_glass = Product.find_or_create(:name => "Silicate Glass"){|product| product.p_level = 2}
superconductors = Product.find_or_create(:name => "Superconductors"){|product| product.p_level = 2}
supertensile_plastics = Product.find_or_create(:name => "Supertensile Plastics"){|product| product.p_level = 2}
synthetic_oil = Product.find_or_create(:name => "Synthetic Oil"){|product| product.p_level = 2}
test_cultures = Product.find_or_create(:name => "Test Cultures"){|product| product.p_level = 2}
transmitter = Product.find_or_create(:name => "Transmitter"){|product| product.p_level = 2}
viral_agent = Product.find_or_create(:name => "Viral Agent"){|product| product.p_level = 2}
water_cooled_cpu = Product.find_or_create(:name => "Water-Cooled CPU"){|product| product.p_level = 2}

# P3 Commodities
biotech_research_reports = Product.find_or_create(:name => "Biotech Research Reports"){|product| product.p_level = 3}
camera_drones = Product.find_or_create(:name => "Camera Drones"){|product| product.p_level = 3}
condensates = Product.find_or_create(:name => "Condensates"){|product| product.p_level = 3}
cryoprotectant_solution = Product.find_or_create(:name => "Cryoprotectant Solution"){|product| product.p_level = 3}
data_chips = Product.find_or_create(:name => "Data Chips"){|product| product.p_level = 3}
gel_matrix_biopaste = Product.find_or_create(:name => "Gel-Matrix Biopaste"){|product| product.p_level = 3}
guidance_systems = Product.find_or_create(:name => "Guidance Systems"){|product| product.p_level = 3}
hazmat_detection_systems = Product.find_or_create(:name => "Hazmat Detection Systems"){|product| product.p_level = 3}
hermetic_membranes = Product.find_or_create(:name => "Hermetic Membranes"){|product| product.p_level = 3}
high_tech_transmitters = Product.find_or_create(:name => "High-Tech Transmitters"){|product| product.p_level = 3}
industrial_explosives = Product.find_or_create(:name => "Industrial Explosives"){|product| product.p_level = 3}
neocoms = Product.find_or_create(:name => "Neocoms"){|product| product.p_level = 3}
nuclear_reactors = Product.find_or_create(:name => "Nuclear Reactors"){|product| product.p_level = 3}
planetary_vehicles = Product.find_or_create(:name => "Planetary Vehicles"){|product| product.p_level = 3}
robotics = Product.find_or_create(:name => "Robotics"){|product| product.p_level = 3}
smartfab_units = Product.find_or_create(:name => "Smartfab Units"){|product| product.p_level = 3}
supercomputers = Product.find_or_create(:name => "Supercomputers"){|product| product.p_level = 3}
synthetic_synapses = Product.find_or_create(:name => "Synthetic Synapses"){|product| product.p_level = 3}
transcranial_microcontrollers = Product.find_or_create(:name => "Transcranial Microcontrollers"){|product| product.p_level = 3}
ukomi_superconductors = Product.find_or_create(:name => "Ukomi Superconductors"){|product| product.p_level = 3}
vaccines = Product.find_or_create(:name => "Vaccines"){|product| product.p_level = 3}

# P4 Commodities
broadcast_node = Product.find_or_create(:name => "Broadcast Node"){|product| product.p_level = 4}
integrity_response_drones = Product.find_or_create(:name => "Integrity Response Drones"){|product| product.p_level = 4}
nano_factory = Product.find_or_create(:name => "Nano-Factory"){|product| product.p_level = 4}
organic_mortar_applicators = Product.find_or_create(:name => "Organic Mortar Applicators"){|product| product.p_level = 4}
recursive_computing_module = Product.find_or_create(:name => "Recursive Computing Module"){|product| product.p_level = 4}
self_harmonizing_power_core = Product.find_or_create(:name => "Self-Harmonizing Power Core"){|product| product.p_level = 4}
sterile_conduits = Product.find_or_create(:name => "Sterile Conduits"){|product| product.p_level = 4}
wetware_mainframe = Product.find_or_create(:name => "Wetware Mainframe"){|product| product.p_level = 4}




# Schematics

# P0 -> P1 Schematics.
Schematic.find_or_create(:output_product_id => bacteria.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = microorganisms.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => biofuels.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = carbon_compounds.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => biomass.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = planktic_colonies.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => chiral_structures.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = non_cs_crystals.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => electrolytes.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = ionic_solutions.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => industrial_fibers.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = autotrophs.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => oxidizing_compound.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = reactive_gas.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => oxygen.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = noble_gas.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => plasmoids.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = suspended_plasma.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => precious_metals.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = noble_metals.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => proteins.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = complex_organisms.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => reactive_metals.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = base_metals.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => silicon.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = felsic_magma.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end
               
Schematic.find_or_create(:output_product_id => toxic_metals.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = heavy_metals.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end

Schematic.find_or_create(:output_product_id => water.id) do |schematic|
  schematic.output_product_quantity = 20
  schematic.primary_input_product_id = aqueous_liquids.id
  schematic.primary_input_product_quantity = 3000
  schematic.p_level = 1
end


# P1 -> P2 schematics.
Schematic.find_or_create(:output_product_id => biocells.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = biofuels.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = precious_metals.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => construction_blocks.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = reactive_metals.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = toxic_metals.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => consumer_electronics.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = toxic_metals.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = chiral_structures.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => coolant.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = electrolytes.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = water.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => enriched_uranium.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = precious_metals.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = toxic_metals.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => fertilizer.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = bacteria.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = proteins.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => genetically_enhanced_livestock.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = proteins.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = biomass.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => livestock.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = proteins.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = biofuels.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => mechanical_parts.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = reactive_metals.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = precious_metals.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => microfiber_shielding.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = industrial_fibers.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = silicon.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => miniature_electronics.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = chiral_structures.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = silicon.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => nanites.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = bacteria.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = reactive_metals.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => oxides.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = oxidizing_compound.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = oxygen.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => polyaramids.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = oxidizing_compound.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = industrial_fibers.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => polytextiles.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = biofuels.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = industrial_fibers.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => rocket_fuel.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = plasmoids.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = electrolytes.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => silicate_glass.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = oxidizing_compound.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = silicon.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => superconductors.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = plasmoids.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = water.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => supertensile_plastics.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = oxygen.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = biomass.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => synthetic_oil.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = electrolytes.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = oxygen.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => test_cultures.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = bacteria.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = water.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => transmitter.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = plasmoids.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = chiral_structures.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => viral_agent.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = bacteria.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = biomass.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

Schematic.find_or_create(:output_product_id => water_cooled_cpu.id) do |schematic|
  schematic.output_product_quantity = 5
  schematic.primary_input_product_id = reactive_metals.id
  schematic.primary_input_product_quantity = 40
  schematic.secondary_input_product_id = water.id
  schematic.secondary_input_product_quantity = 40
  schematic.p_level = 2
end

# P2 -> P3 schematics.
Schematic.find_or_create(:output_product_id => biotech_research_reports.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = nanites.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = livestock.id
  schematic.secondary_input_product_quantity = 10
  schematic.tertiary_input_product_id = construction_blocks.id
  schematic.tertiary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => camera_drones.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = silicate_glass.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = rocket_fuel.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => condensates.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = oxides.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = coolant.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => cryoprotectant_solution.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = test_cultures.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = synthetic_oil.id
  schematic.secondary_input_product_quantity = 10
  schematic.tertiary_input_product_id = fertilizer.id
  schematic.tertiary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => data_chips.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = supertensile_plastics.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = microfiber_shielding.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => gel_matrix_biopaste.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = oxides.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = biocells.id
  schematic.secondary_input_product_quantity = 10
  schematic.tertiary_input_product_id = superconductors.id
  schematic.tertiary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => guidance_systems.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = water_cooled_cpu.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = transmitter.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => hazmat_detection_systems.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = polytextiles.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = viral_agent.id
  schematic.secondary_input_product_quantity = 10
  schematic.tertiary_input_product_id = transmitter.id
  schematic.tertiary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => hermetic_membranes.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = polyaramids.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = genetically_enhanced_livestock.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => high_tech_transmitters.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = polyaramids.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = transmitter.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => industrial_explosives.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = fertilizer.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = polytextiles.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => neocoms.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = biocells.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = silicate_glass.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => nuclear_reactors.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = enriched_uranium.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = microfiber_shielding.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => planetary_vehicles.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = supertensile_plastics.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = mechanical_parts.id
  schematic.secondary_input_product_quantity = 10
  schematic.tertiary_input_product_id = miniature_electronics.id
  schematic.tertiary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => robotics.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = mechanical_parts.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = consumer_electronics.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => smartfab_units.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = construction_blocks.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = miniature_electronics.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => supercomputers.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = water_cooled_cpu.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = coolant.id
  schematic.secondary_input_product_quantity = 10
  schematic.tertiary_input_product_id = consumer_electronics.id
  schematic.tertiary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => synthetic_synapses.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = supertensile_plastics.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = test_cultures.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => transcranial_microcontrollers.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = biocells.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = nanites.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => ukomi_superconductors.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = synthetic_oil.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = superconductors.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

Schematic.find_or_create(:output_product_id => vaccines.id) do |schematic|
  schematic.output_product_quantity = 3
  schematic.primary_input_product_id = livestock.id
  schematic.primary_input_product_quantity = 10
  schematic.secondary_input_product_id = viral_agent.id
  schematic.secondary_input_product_quantity = 10
  schematic.p_level = 3
end

# P3 -> P4 schematics.
Schematic.find_or_create(:output_product_id => broadcast_node.id) do |schematic|
  schematic.output_product_quantity = 1
  schematic.primary_input_product_id = neocoms.id
  schematic.primary_input_product_quantity = 6
  schematic.secondary_input_product_id = data_chips.id
  schematic.secondary_input_product_quantity = 6
  schematic.tertiary_input_product_id = high_tech_transmitters.id
  schematic.tertiary_input_product_quantity = 6
  schematic.p_level = 4
end

Schematic.find_or_create(:output_product_id => integrity_response_drones.id) do |schematic|
  schematic.output_product_quantity = 1
  schematic.primary_input_product_id = gel_matrix_biopaste.id
  schematic.primary_input_product_quantity = 6
  schematic.secondary_input_product_id = hazmat_detection_systems.id
  schematic.secondary_input_product_quantity = 6
  schematic.tertiary_input_product_id = planetary_vehicles.id
  schematic.tertiary_input_product_quantity = 6
  schematic.p_level = 4
end

Schematic.find_or_create(:output_product_id => nano_factory.id) do |schematic|
  schematic.output_product_quantity = 1
  schematic.primary_input_product_id = industrial_explosives.id
  schematic.primary_input_product_quantity = 6
  schematic.secondary_input_product_id = reactive_metals.id
  schematic.secondary_input_product_quantity = 40
  schematic.tertiary_input_product_id = ukomi_superconductors.id
  schematic.tertiary_input_product_quantity = 6
  schematic.p_level = 4
end

Schematic.find_or_create(:output_product_id => organic_mortar_applicators.id) do |schematic|
  schematic.output_product_quantity = 1
  schematic.primary_input_product_id = condensates.id
  schematic.primary_input_product_quantity = 6
  schematic.secondary_input_product_id = bacteria.id
  schematic.secondary_input_product_quantity = 40
  schematic.tertiary_input_product_id = robotics.id
  schematic.tertiary_input_product_quantity = 6
  schematic.p_level = 4
end

Schematic.find_or_create(:output_product_id => recursive_computing_module.id) do |schematic|
  schematic.output_product_quantity = 1
  schematic.primary_input_product_id = synthetic_synapses.id
  schematic.primary_input_product_quantity = 6
  schematic.secondary_input_product_id = guidance_systems.id
  schematic.secondary_input_product_quantity = 6
  schematic.tertiary_input_product_id = transcranial_microcontrollers.id
  schematic.tertiary_input_product_quantity = 6
  schematic.p_level = 4
end

Schematic.find_or_create(:output_product_id => self_harmonizing_power_core.id) do |schematic|
  schematic.output_product_quantity = 1
  schematic.primary_input_product_id = camera_drones.id
  schematic.primary_input_product_quantity = 6
  schematic.secondary_input_product_id = nuclear_reactors.id
  schematic.secondary_input_product_quantity = 6
  schematic.tertiary_input_product_id = hermetic_membranes.id
  schematic.tertiary_input_product_quantity = 6
  schematic.p_level = 4
end

Schematic.find_or_create(:output_product_id => sterile_conduits.id) do |schematic|
  schematic.output_product_quantity = 1
  schematic.primary_input_product_id = smartfab_units.id
  schematic.primary_input_product_quantity = 6
  schematic.secondary_input_product_id = water.id
  schematic.secondary_input_product_quantity = 40
  schematic.tertiary_input_product_id = vaccines.id
  schematic.tertiary_input_product_quantity = 6
  schematic.p_level = 4
end

Schematic.find_or_create(:output_product_id => wetware_mainframe.id) do |schematic|
  schematic.output_product_quantity = 1
  schematic.primary_input_product_id = supercomputers.id
  schematic.primary_input_product_quantity = 6
  schematic.secondary_input_product_id = biotech_research_reports.id
  schematic.secondary_input_product_quantity = 6
  schematic.tertiary_input_product_id = cryoprotectant_solution.id
  schematic.tertiary_input_product_quantity = 6
  schematic.p_level = 4
end

