require 'test/unit'

# All model/ tests.

# PI Configuration
require_relative './test_case_pi_configuration.rb'

# Planet
require_relative './test_case_planet.rb'

# Buildings
require_relative './test_case_command_center.rb'
require_relative './test_case_basic_industrial_facility.rb'
require_relative './test_case_advanced_industrial_facility.rb'
require_relative './test_case_high_tech_industrial_facility.rb'
require_relative './test_case_launchpad.rb'
require_relative './test_case_storage_facility.rb'
require_relative './test_case_extractor.rb'
require_relative './test_case_extractor_head.rb'
require_relative './test_case_planetary_link.rb'
require_relative './test_case_production_cycle.rb'

# Products, Schematics, Etc.
require_relative './test_case_product.rb'
require_relative './test_case_schematic.rb'

# Helper Modules
require_relative './test_case_unrestricted_storage.rb'
require_relative './test_case_industrial_facility_storage.rb'