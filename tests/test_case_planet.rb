require "test/unit"

require_relative "../model/planet.rb"

class TestCasePlanet < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	# Use a Temperate planet by default so no buildings are inherently restricted.
	@planet = Planet.new("Temperate")
	@was_notified_of_change = false
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_planet_type_changes_when_planet_type_is_set
	assert_equal("Temperate", @planet.type)
	
	@planet.type = "Lava"
	
	assert_equal("Lava", @planet.type)
  end
  
  def test_error_occurs_and_planet_type_does_not_change_when_planet_type_is_set_to_invalid_value
	assert_equal("Temperate", @planet.type)
	
	# There is no Unicorn planet.
	assert_raise ArgumentError do
	  @planet.type = "Unicorn"
	end
	
	# There is no numeric planet.
	assert_raise ArgumentError do
	  @planet.type = (1236423254)
	end
	
	# Make sure the planet is unchanged.
	assert_equal("Temperate", @planet.type)
  end
  
  def test_planet_name_changes_when_planet_name_is_set
	assert_equal(nil, @planet.name)
	
	@planet.name = "J100820 - III"
	
	assert_equal("J100820 - III", @planet.name)
  end
  
  def test_error_occurs_and_planet_name_does_not_change_when_planet_name_is_set_to_invalid_value
	assert_equal(nil, @planet.name)
	
	# Should fail because it's not a string.
	assert_raise ArgumentError do
	  @planet.name = (1236423254)
	end
	
	# Make sure the planet is unchanged.
	assert_equal(nil, @planet.name)
  end
  
  def test_planet_starts_with_zero_buildings
	assert_equal(0, @planet.buildings.count)
	assert_equal(0, @planet.num_buildings)
  end
  
  def test_can_add_building_from_instance
	command_center = CommandCenter.new
	
	@planet.add_building(command_center)
	
	assert_equal(1, @planet.num_buildings)
	assert_true(@planet.buildings.include?(command_center))
  end
  
  def test_can_add_building_from_class_name
	@planet.add_building_from_class(CommandCenter)
	
	assert_equal(1, @planet.num_buildings)
	
	@planet.buildings.each do |building|
	  assert_true(building.is_a?(CommandCenter))
	end
  end
  
  def test_cannot_add_more_than_one_command_center
	# Test it with the add_building method.
	first_command_center = CommandCenter.new
	second_command_center = CommandCenter.new
	
	@planet.add_building(first_command_center)
	
	assert_raise ArgumentError do
	  @planet.add_building(second_command_center)
	end
	
	@planet.remove_building(first_command_center)
	
	# Make sure we don't have any buildings at this point.
	assert_equal(0, @planet.buildings.count)
	assert_equal(0, @planet.num_buildings)
	
	
	
	
	# Now, test it with the add_building_from_class method.
	third_command_center = @planet.add_building_from_class(CommandCenter)
	
	assert_raise ArgumentError do
	  @planet.add_building_from_class(CommandCenter)
	end
	
	@planet.remove_building(third_command_center)
	
	# Make sure we don't have any buildings at this point.
	assert_equal(0, @planet.buildings.count)
	assert_equal(0, @planet.num_buildings)
  end
  
  def test_planet_has_a_customs_office_by_default
	assert_true(@planet.customs_office.is_a?(CustomsOffice))
  end
  
  def test_planet_cannot_add_or_remove_a_customs_office
	assert_raise NoMethodError do
	  @planet.add_customs_office
	end
	
	assert_raise NoMethodError do
	  @planet.remove_customs_office
	end
  end
  
  def test_cannot_add_high_tech_industrial_facility_unless_planet_type_supports_it
	gas_planet = Planet.new("Gas")
	ice_planet = Planet.new("Ice")
	storm_planet = Planet.new("Storm")
	barren_planet = Planet.new("Barren")
	temperate_planet = Planet.new("Temperate")
	lava_planet = Planet.new("Lava")
	oceanic_planet = Planet.new("Oceanic")
	plasma_planet = Planet.new("Plasma")
	
	assert_raise ArgumentError do
	  gas_planet.add_building_from_class(HighTechIndustrialFacility)
	end
	
	assert_raise ArgumentError do
	  ice_planet.add_building_from_class(HighTechIndustrialFacility)
	end
	
	assert_raise ArgumentError do
	  storm_planet.add_building_from_class(HighTechIndustrialFacility)
	end
	
	assert_nothing_thrown do
	  barren_planet.add_building_from_class(HighTechIndustrialFacility)
	end
	
	assert_nothing_thrown do
	  temperate_planet.add_building_from_class(HighTechIndustrialFacility)
	end
	
	assert_raise ArgumentError do
	  lava_planet.add_building_from_class(HighTechIndustrialFacility)
	end
	
	assert_raise ArgumentError do
	  oceanic_planet.add_building_from_class(HighTechIndustrialFacility)
	end
	
	assert_raise ArgumentError do
	  plasma_planet.add_building_from_class(HighTechIndustrialFacility)
	end
  end
  
  def test_adding_planet_from_class_name_returns_instance
	test_building = @planet.add_building_from_class(CommandCenter)
	
	assert_true(test_building.is_a?(CommandCenter))
  end
  
  def test_building_planet_ref_is_set_when_building_is_added
	command_center = CommandCenter.new
	
	@planet.add_building(command_center)
	
	@planet.buildings.each do |building|
	  assert_equal(@planet, building.planet)
	end
  end
  
  def test_building_planet_ref_is_set_when_building_is_added_from_class_name
	@planet.add_building_from_class(CommandCenter)
	
	@planet.buildings.each do |building|
	  assert_equal(@planet, building.planet)
	end
  end
  
  def test_can_remove_specific_building_instance
	command_center = CommandCenter.new
	
	@planet.add_building(command_center)
	
	@planet.remove_building(command_center)
	
	assert_equal(0, @planet.num_buildings)
	assert_equal(0, @planet.buildings.count)
  end
  
  def test_building_planet_ref_is_cleared_when_building_is_removed
	command_center = CommandCenter.new
	
	@planet.add_building(command_center)
	
	assert_equal(@planet, command_center.planet)
	
	@planet.remove_building(command_center)
	
	assert_equal(nil, command_center.planet)
  end
  
  def test_can_remove_all_buildings
	command_center = CommandCenter.new
	extractor = Extractor.new
	
	@planet.add_building(command_center)
	@planet.add_building(extractor)
	
	assert_equal(2, @planet.num_buildings)
	assert_equal(2, @planet.buildings.count)
	
	@planet.remove_all_buildings
	
	assert_equal(0, @planet.num_buildings)
	assert_equal(0, @planet.buildings.count)
  end
  
  def test_can_abandon_planet_completely
	command_center = CommandCenter.new
	extractor = Extractor.new
	
	@planet.add_building(command_center)
	@planet.add_building(extractor)
	
	assert_equal(2, @planet.num_buildings)
	assert_equal(2, @planet.buildings.count)
	
	@planet.type = "Lava"
	@planet.name = "J100820 - III"
	
	@planet.abandon
	
	assert_equal(0, @planet.num_buildings)
	assert_equal(0, @planet.buildings.count)
	
	assert_equal("Uncolonized", @planet.type)
	assert_equal(nil, @planet.name)
  end
  
  def test_powergrid_usage_scales_with_number_of_buildings
	# 0 # Command Center
	# 700 # Storage Facility
	# 700 # Launchpad
	# 2600 # Extractor
	# 550 # Extractor Head
	# 800 # Basic Industrial Facility
	# 700 # Advanced Industrial Facility
	# 400 # High Tech Industrial Facility
	
	assert_equal(0, @planet.powergrid_usage)
	
	@planet.add_building_from_class(CommandCenter)
	
	assert_equal(0, @planet.powergrid_usage)
	
	@planet.add_building_from_class(StorageFacility)
	
	assert_equal(700, @planet.powergrid_usage)
	
	@planet.add_building_from_class(Launchpad)
	
	assert_equal(1400, @planet.powergrid_usage)
	
	extractor = @planet.add_building_from_class(Extractor)
	
	assert_equal(4000, @planet.powergrid_usage)
	
	extractor.add_extractor_head
	
	assert_equal(4550, @planet.powergrid_usage)
	
	@planet.add_building_from_class(BasicIndustrialFacility)
	
	assert_equal(5350, @planet.powergrid_usage)
	
	@planet.add_building_from_class(AdvancedIndustrialFacility)
	
	assert_equal(6050, @planet.powergrid_usage)
	
	@planet.add_building_from_class(HighTechIndustrialFacility)
	
	assert_equal(6450, @planet.powergrid_usage)
  end
  
  def test_cpu_usage_scales_with_number_of_buildings
	# 0 # Command Center
	# 500 # Storage Facility
	# 3600 # Launchpad
	# 400 # Extractor
	# 110 # Extractor Head
	# 200 # Basic Industrial Facility
	# 500 # Advanced Industrial Facility
	# 1100 # High Tech Industrial Facility
	
	assert_equal(0, @planet.cpu_usage)
	
	@planet.add_building_from_class(CommandCenter)
	
	assert_equal(0, @planet.cpu_usage)
	
	@planet.add_building_from_class(StorageFacility)
	
	assert_equal(500, @planet.cpu_usage)
	
	@planet.add_building_from_class(Launchpad)
	
	assert_equal(4100, @planet.cpu_usage)
	
	extractor = @planet.add_building_from_class(Extractor)
	
	assert_equal(4500, @planet.cpu_usage)
	
	extractor.add_extractor_head
	
	assert_equal(4610, @planet.cpu_usage)
	
	@planet.add_building_from_class(BasicIndustrialFacility)
	
	assert_equal(4810, @planet.cpu_usage)
	
	@planet.add_building_from_class(AdvancedIndustrialFacility)
	
	assert_equal(5310, @planet.cpu_usage)
	
	@planet.add_building_from_class(HighTechIndustrialFacility)
	
	assert_equal(6410, @planet.cpu_usage)
  end
  
  def test_powergrid_usage_scales_with_links
	storage_a = @planet.add_building_from_class(StorageFacility)
	storage_b = @planet.add_building_from_class(StorageFacility)
	
	link = @planet.add_link(storage_a, storage_b)
	link.length = 1000
	
	assert_equal((link.powergrid_usage + storage_a.powergrid_usage + storage_b.powergrid_usage), @planet.powergrid_usage)
  end
  
  def test_cpu_usage_scales_with_links
	storage_a = @planet.add_building_from_class(StorageFacility)
	storage_b = @planet.add_building_from_class(StorageFacility)
	
	link = @planet.add_link(storage_a, storage_b)
	link.length = 1000
	
	assert_equal((link.cpu_usage + storage_a.cpu_usage + storage_b.cpu_usage), @planet.cpu_usage)
  end
  
  def test_powergrid_provided_scales_with_number_of_buildings
	# 6000 # Command Center
	# 0 # Storage Facility
	# 0 # Launchpad
	# 0 # Extractor
	# 0 # Extractor Head
	# 0 # Basic Industrial Facility
	# 0 # Advanced Industrial Facility
	# 0 # High Tech Industrial Facility
	
	assert_equal(0, @planet.powergrid_provided)
	
	@planet.add_building_from_class(CommandCenter)
	
	assert_equal(6000, @planet.powergrid_provided)
	
	@planet.add_building_from_class(StorageFacility)
	
	assert_equal(6000, @planet.powergrid_provided)
	
	@planet.add_building_from_class(Launchpad)
	
	assert_equal(6000, @planet.powergrid_provided)
	
	extractor = @planet.add_building_from_class(Extractor)
	
	assert_equal(6000, @planet.powergrid_provided)
	
	extractor.add_extractor_head
	
	assert_equal(6000, @planet.powergrid_provided)
	
	@planet.add_building_from_class(BasicIndustrialFacility)
	
	assert_equal(6000, @planet.powergrid_provided)
	
	@planet.add_building_from_class(AdvancedIndustrialFacility)
	
	assert_equal(6000, @planet.powergrid_provided)
	
	@planet.add_building_from_class(HighTechIndustrialFacility)
	
	assert_equal(6000, @planet.powergrid_provided)
  end
  
  def test_cpu_provided_scales_with_number_of_buildings
	# 1675 # Command Center
	# 0 # Storage Facility
	# 0 # Launchpad
	# 0 # Extractor
	# 0 # Extractor Head
	# 0 # Basic Industrial Facility
	# 0 # Advanced Industrial Facility
	# 0 # High Tech Industrial Facility
	
	assert_equal(0, @planet.cpu_provided)
	
	@planet.add_building_from_class(CommandCenter)
	
	assert_equal(1675, @planet.cpu_provided)
	
	@planet.add_building_from_class(StorageFacility)
	
	assert_equal(1675, @planet.cpu_provided)
	
	@planet.add_building_from_class(Launchpad)
	
	assert_equal(1675, @planet.cpu_provided)
	
	extractor = @planet.add_building_from_class(Extractor)
	
	assert_equal(1675, @planet.cpu_provided)
	
	extractor.add_extractor_head
	
	assert_equal(1675, @planet.cpu_provided)
	
	@planet.add_building_from_class(BasicIndustrialFacility)
	
	assert_equal(1675, @planet.cpu_provided)
	
	@planet.add_building_from_class(AdvancedIndustrialFacility)
	
	assert_equal(1675, @planet.cpu_provided)
	
	@planet.add_building_from_class(HighTechIndustrialFacility)
	
	assert_equal(1675, @planet.cpu_provided)
  end
  
  def test_pct_powergrid_usage_returns_zero_if_dividing_by_zero
	assert_equal(0, @planet.num_buildings)
	assert_equal(0, @planet.pct_powergrid_usage)
  end
  
  def test_pct_powergrid_usage_returns_accurate_percentage
	@planet.add_building_from_class(CommandCenter)
	
	# 0 used / 6000 provided = 0% used.
	assert_equal(0, @planet.pct_powergrid_usage)
	
	@planet.add_building_from_class(Extractor)
	algorithm = (@planet.powergrid_usage * (100.0 / @planet.powergrid_provided))
	assert_equal(algorithm, @planet.pct_powergrid_usage)
	
	@planet.add_building_from_class(StorageFacility)
	algorithm = (@planet.powergrid_usage * (100.0 / @planet.powergrid_provided))
	assert_equal(algorithm, @planet.pct_powergrid_usage)
  end
  
  def test_pct_cpu_usage_returns_zero_if_dividing_by_zero
	assert_equal(0, @planet.num_buildings)
	assert_equal(0, @planet.pct_cpu_usage)
  end
  
  def test_pct_cpu_usage_returns_accurate_percentage
	@planet.add_building_from_class(CommandCenter)
	
	# 0 used / 1675 provided = 0% used.
	assert_equal(0, @planet.pct_cpu_usage)
	
	@planet.add_building_from_class(Extractor)
	algorithm = (@planet.cpu_usage * (100.0 / @planet.cpu_provided))
	assert_equal(algorithm, @planet.pct_cpu_usage)
	
	@planet.add_building_from_class(StorageFacility)
	algorithm = (@planet.cpu_usage * (100.0 / @planet.cpu_provided))
	assert_equal(algorithm, @planet.pct_cpu_usage)
  end
  
  def test_isk_cost_scales_with_number_of_buildings
	# 90000.00 # Command Center
	# 250000.00 # Storage Facility
	# 900000.00 # Launchpad
	# 45000.00 # Extractor
	# 0 # Extractor Head
	# 75000.00 # Basic Industrial Facility
	# 250000.00 # Advanced Industrial Facility
	# 525000.00 # High Tech Industrial Facility
	
	assert_equal(0, @planet.isk_cost)
	
	@planet.add_building_from_class(CommandCenter)
	
	assert_equal(90000.00, @planet.isk_cost)
	
	@planet.add_building_from_class(StorageFacility)
	
	assert_equal(340000.00, @planet.isk_cost)
	
	@planet.add_building_from_class(Launchpad)
	
	assert_equal(1240000.00, @planet.isk_cost)
	
	extractor = @planet.add_building_from_class(Extractor)
	
	assert_equal(1285000.00, @planet.isk_cost)
	
	extractor.add_extractor_head
	
	assert_equal(1285000.00, @planet.isk_cost)
	
	@planet.add_building_from_class(BasicIndustrialFacility)
	
	assert_equal(1360000.00, @planet.isk_cost)
	
	@planet.add_building_from_class(AdvancedIndustrialFacility)
	
	assert_equal(1610000.00, @planet.isk_cost)
	
	@planet.add_building_from_class(HighTechIndustrialFacility)
	
	assert_equal(2135000.00, @planet.isk_cost)
  end
  
  def test_isk_cost_scales_with_links
	storage_a = @planet.add_building_from_class(StorageFacility)
	storage_b = @planet.add_building_from_class(StorageFacility)
	
	link = @planet.add_link(storage_a, storage_b)
	link.length = 1000
	
	assert_equal((link.isk_cost + storage_a.isk_cost + storage_b.isk_cost), @planet.isk_cost)
  end
  
  def test_number_of_command_centers_scales_with_number_of_command_centers
	assert_equal(0, @planet.num_command_centers)
	
	@planet.add_building_from_class(CommandCenter)
	
	assert_equal(1, @planet.num_command_centers)
	
	assert_raise ArgumentError do
	  @planet.add_building_from_class(CommandCenter)
	end
	
	assert_equal(1, @planet.num_command_centers)
	
	# These types should not change the value.
	@planet.add_building_from_class(Launchpad)
	@planet.add_building_from_class(StorageFacility)
	@planet.add_building_from_class(BasicIndustrialFacility)
	@planet.add_building_from_class(AdvancedIndustrialFacility)
	@planet.add_building_from_class(HighTechIndustrialFacility)
	@planet.add_building_from_class(Extractor)
	
	assert_equal(1, @planet.num_command_centers)
  end
  
  def test_number_of_factories_scales_with_number_of_factories
	assert_equal(0, @planet.num_factories)
	
	@planet.add_building_from_class(BasicIndustrialFacility)
	
	assert_equal(1, @planet.num_factories)
	
	@planet.add_building_from_class(BasicIndustrialFacility)
	
	assert_equal(2, @planet.num_factories)
	
	@planet.add_building_from_class(AdvancedIndustrialFacility)
	
	assert_equal(3, @planet.num_factories)
	
	@planet.add_building_from_class(AdvancedIndustrialFacility)
	
	assert_equal(4, @planet.num_factories)
	
	@planet.add_building_from_class(HighTechIndustrialFacility)
	
	assert_equal(5, @planet.num_factories)
	
	@planet.add_building_from_class(HighTechIndustrialFacility)
	
	assert_equal(6, @planet.num_factories)
	
	# These types should not change the value.
	@planet.add_building_from_class(CommandCenter)
	@planet.add_building_from_class(StorageFacility)
	@planet.add_building_from_class(Launchpad)
	@planet.add_building_from_class(Extractor)
	
	assert_equal(6, @planet.num_factories)
  end
  
  def test_number_of_launchpads_scales_with_number_of_launchpads
	assert_equal(0, @planet.num_launchpads)
	
	@planet.add_building_from_class(Launchpad)
	
	assert_equal(1, @planet.num_launchpads)
	
	@planet.add_building_from_class(Launchpad)
	
	assert_equal(2, @planet.num_launchpads)
	
	@planet.add_building_from_class(Launchpad)
	
	assert_equal(3, @planet.num_launchpads)
	
	# These types should not change the value.
	@planet.add_building_from_class(CommandCenter)
	@planet.add_building_from_class(StorageFacility)
	@planet.add_building_from_class(BasicIndustrialFacility)
	@planet.add_building_from_class(AdvancedIndustrialFacility)
	@planet.add_building_from_class(HighTechIndustrialFacility)
	@planet.add_building_from_class(Extractor)
	
	assert_equal(3, @planet.num_launchpads)
  end
  
  def test_number_of_storage_facilities_scales_with_number_of_storage_facilities
	assert_equal(0, @planet.num_storages)
	
	@planet.add_building_from_class(StorageFacility)
	
	assert_equal(1, @planet.num_storages)
	
	@planet.add_building_from_class(StorageFacility)
	
	assert_equal(2, @planet.num_storages)
	
	@planet.add_building_from_class(StorageFacility)
	
	assert_equal(3, @planet.num_storages)
	
	# These types should not change the value.
	@planet.add_building_from_class(CommandCenter)
	@planet.add_building_from_class(Launchpad)
	@planet.add_building_from_class(BasicIndustrialFacility)
	@planet.add_building_from_class(AdvancedIndustrialFacility)
	@planet.add_building_from_class(HighTechIndustrialFacility)
	@planet.add_building_from_class(Extractor)
	
	assert_equal(3, @planet.num_storages)
  end
  
  def test_aggregate_launchpads_ccs_storages_scales_with_launchpads_ccs_and_storages
	assert_equal(0, @planet.num_aggregate_launchpads_ccs_storages)
	
	@planet.add_building_from_class(Launchpad)
	
	assert_equal(1, @planet.num_aggregate_launchpads_ccs_storages)
	
	@planet.add_building_from_class(CommandCenter)
	
	assert_equal(2, @planet.num_aggregate_launchpads_ccs_storages)
	
	@planet.add_building_from_class(StorageFacility)
	
	assert_equal(3, @planet.num_aggregate_launchpads_ccs_storages)
	
	# These types should not change the value.
	@planet.add_building_from_class(BasicIndustrialFacility)
	@planet.add_building_from_class(AdvancedIndustrialFacility)
	@planet.add_building_from_class(HighTechIndustrialFacility)
	@planet.add_building_from_class(Extractor)
	
	assert_equal(3, @planet.num_aggregate_launchpads_ccs_storages)
  end
  
  def test_can_add_a_link
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	
	added_link = @planet.add_link(storage_facility_a, storage_facility_b)
	assert_true(added_link.is_a?(PlanetaryLink))
  end
  
  def test_when_adding_a_link_that_already_exists_a_new_one_is_not_created
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	
	# Make sure if we re-run the same command we get the same instance.
	first_link = @planet.add_link(storage_facility_a, storage_facility_b)
	second_link = @planet.add_link(storage_facility_a, storage_facility_b)
	assert_equal(first_link, second_link)
	
	# Make sure we get the same instance even if we flip the destination and source around.
	third_link = @planet.add_link(storage_facility_b, storage_facility_a)
	assert_equal(first_link, third_link)
  end
  
  def test_links_gives_array_of_links
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	launchpad_a = Launchpad.new
	launchpad_b = Launchpad.new
	extractor_a = Extractor.new
	extractor_b = Extractor.new
	
	first_link = @planet.add_link(storage_facility_a, storage_facility_b)
	second_link = @planet.add_link(launchpad_a, launchpad_b)
	third_link = @planet.add_link(extractor_a, extractor_b)
	
	known_links = [first_link, second_link, third_link]
	
	assert_equal(known_links, @planet.links)
  end
  
  def test_can_find_all_links_for_a_building
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	launchpad_a = Launchpad.new
	launchpad_b = Launchpad.new
	extractor_a = Extractor.new
	extractor_b = Extractor.new
	
	first_link = @planet.add_link(storage_facility_a, storage_facility_b)
	second_link = @planet.add_link(launchpad_a, launchpad_b)
	third_link = @planet.add_link(extractor_a, extractor_b)
	fourth_link = @planet.add_link(extractor_b, storage_facility_b)
	
	assert_equal([third_link], @planet.find_links_connected_to(extractor_a))
	assert_equal([third_link, fourth_link], @planet.find_links_connected_to(extractor_b))
	assert_equal([first_link, fourth_link], @planet.find_links_connected_to(storage_facility_b))
  end
  
  def test_can_find_a_specific_link_by_buildings
	storage_facility_a = StorageFacility.new
	launchpad_a = Launchpad.new
	launchpad_b = Launchpad.new
	extractor_a = Extractor.new
	extractor_b = Extractor.new
	
	# Create a bunch of links all attached to launchpad_a.
	# Note that some of these have launchpad_a as a source, and some as a destination.
	# Order /shouldn't/ matter.
	first_link = @planet.add_link(launchpad_a, launchpad_b)
	second_link = @planet.add_link(extractor_a, launchpad_a)
	third_link = @planet.add_link(extractor_b, launchpad_a)
	fourth_link = @planet.add_link(launchpad_a, storage_facility_a)
	
	# Make sure we can find them if we search with the order they were created.
	assert_equal(first_link, @planet.find_link(launchpad_a, launchpad_b))
	assert_equal(second_link, @planet.find_link(extractor_a, launchpad_a))
	assert_equal(third_link, @planet.find_link(extractor_b, launchpad_a))
	assert_equal(fourth_link, @planet.find_link(launchpad_a, storage_facility_a))
	
	# Make sure we can find them if we search in the opposite order of how they were created.
	assert_equal(first_link, @planet.find_link(launchpad_b, launchpad_a))
	assert_equal(second_link, @planet.find_link(launchpad_a, extractor_a))
	assert_equal(third_link, @planet.find_link(launchpad_a, extractor_b))
	assert_equal(fourth_link, @planet.find_link(storage_facility_a, launchpad_a))	
  end
  
  def test_can_remove_a_link
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	launchpad_a = Launchpad.new
	launchpad_b = Launchpad.new
	extractor_a = Extractor.new
	extractor_b = Extractor.new
	
	first_link = @planet.add_link(storage_facility_a, storage_facility_b)
	second_link = @planet.add_link(launchpad_a, launchpad_b)
	third_link = @planet.add_link(extractor_a, extractor_b)
	
	known_links = [first_link, second_link, third_link]
	known_links_without_two = [first_link, third_link]
	
	assert_equal(known_links, @planet.links)
	
	@planet.remove_link(second_link)
	
	assert_equal(known_links_without_two, @planet.links)
  end
  
  def test_when_building_is_removed_links_are_removed_as_well
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	
	added_link = @planet.add_link(storage_facility_a, storage_facility_b)
	
	assert_true(@planet.find_links_connected_to(storage_facility_b).include?(added_link))
	
	@planet.remove_building(storage_facility_a)
	
	assert_false(@planet.find_links_connected_to(storage_facility_b).include?(added_link))
  end
  
  def test_num_links_scales_with_number_of_links
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	launchpad_a = Launchpad.new
	launchpad_b = Launchpad.new
	extractor_a = Extractor.new
	extractor_b = Extractor.new
	
	first_link = @planet.add_link(storage_facility_a, storage_facility_b)
	second_link = @planet.add_link(launchpad_a, launchpad_b)
	third_link = @planet.add_link(extractor_a, extractor_b)
	
	assert_equal(3, @planet.num_links)
  end
  
  def test_can_get_pzero_product_list
	planet = Planet.new("Temperate")
	
	assert_true(planet.pzero_product_list.include?("Autotrophs"))
	assert_true(planet.pzero_product_list.include?("Carbon Compounds"))
	assert_true(planet.pzero_product_list.include?("Micro Organisms"))
	assert_true(planet.pzero_product_list.include?("Complex Organisms"))
	assert_true(planet.pzero_product_list.include?("Aqueous Liquids"))
	
	assert_false(planet.pzero_product_list.include?("Felsic Magma"))
  end
  
  def test_can_ask_if_planet_has_pzero
	planet = Planet.new("Temperate")
	
	assert_true(planet.has_pzero?("Autotrophs"))
	assert_true(planet.has_pzero?("Carbon Compounds"))
	assert_true(planet.has_pzero?("Micro Organisms"))
	assert_true(planet.has_pzero?("Complex Organisms"))
	assert_true(planet.has_pzero?("Aqueous Liquids"))
	
	assert_false(planet.has_pzero?("Felsic Magma"))
  end
  
  
  #
  # Observable tests
  #
  
  def test_planet_is_observable
	assert_true(@planet.is_a?(Observable), "Planet did not include Observable.")
  end
  
  # Update method for testing observer.
  def update
	@was_notified_of_change = true
  end
  
  def test_planet_notifies_observers_when_its_type_changes
	@planet.add_observer(self)
	
	@planet.type = "Lava"
	
	assert_true(@was_notified_of_change)
	
	@planet.delete_observer(self)
  end
  
  def test_planet_does_not_notify_observers_when_its_type_is_set_to_identical_value
	@planet.type = "Lava"
	
	@planet.add_observer(self)
	
	@planet.type = "Lava"
	
	assert_false(@was_notified_of_change)
	
	@planet.delete_observer(self)
  end
  
  def test_planet_notifies_observers_when_its_name_changes
	@planet.add_observer(self)
	
	@planet.name = "J100820 - III"
	
	assert_true(@was_notified_of_change)
	
	@planet.delete_observer(self)
  end
  
  def test_planet_does_not_notify_observers_when_its_name_is_set_to_identical_value
	@planet.name = "J100820 - III"
	
	@planet.add_observer(self)
	
	@planet.name = "J100820 - III"
	
	assert_false(@was_notified_of_change)
	
	@planet.delete_observer(self)
  end
    
  def test_planet_notifies_observers_when_it_adds_a_building
	@planet.add_observer(self)
	
	first_extractor = Extractor.new
	@planet.add_building(first_extractor)
	
	assert_true(@was_notified_of_change)
	
	# Reset
	@was_notified_of_change = false
	
	@planet.add_building_from_class(Extractor)
	
	assert_true(@was_notified_of_change)
	
	@planet.delete_observer(self)
  end
  
  def test_planet_notifies_observers_when_it_removes_a_building
	first_extractor = Extractor.new
	@planet.add_building(first_extractor)
	
	@planet.add_observer(self)
	
	@planet.remove_building(first_extractor)
	
	assert_true(@was_notified_of_change)
	
	@planet.delete_observer(self)
  end
  
  def test_planet_notifies_observers_when_it_removes_all_buildings
	first_extractor = Extractor.new
	first_command_center = CommandCenter.new
	@planet.add_building(first_extractor)
	@planet.add_building(first_command_center)
	
	@planet.add_observer(self)
	
	@planet.remove_all_buildings
	
	assert_true(@was_notified_of_change)
	
	@planet.delete_observer(self)
  end
  
  def test_planet_notifies_observers_when_it_is_abandoned
	command_center = CommandCenter.new
	extractor = Extractor.new
	
	@planet.add_building(command_center)
	@planet.add_building(extractor)
	
	assert_equal(2, @planet.num_buildings)
	assert_equal(2, @planet.buildings.count)
	
	@planet.type = "Lava"
	@planet.name = "J100820 - III"
	
	@planet.add_observer(self)
	
	@planet.abandon
	
	assert_true(@was_notified_of_change)
	
	@planet.delete_observer(self)
  end
end