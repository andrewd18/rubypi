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
	@planet = Planet.new("Uncolonized")
	@was_notified_of_change = false
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_planet_type_changes_when_planet_type_is_set
	assert_equal("Uncolonized", @planet.type)
	
	@planet.type = "Lava"
	
	assert_equal("Lava", @planet.type)
  end
  
  def test_error_occurs_and_planet_type_does_not_change_when_planet_type_is_set_to_invalid_value
	assert_equal("Uncolonized", @planet.type)
	
	# There is no Unicorn planet.
	assert_raise ArgumentError do
	  @planet.type = "Unicorn"
	end
	
	# There is no numeric planet.
	assert_raise ArgumentError do
	  @planet.type = (1236423254)
	end
	
	# Make sure the planet is unchanged.
	assert_equal("Uncolonized", @planet.type)
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
  
  def test_planet_alias_changes_when_planet_alias_is_set
	assert_equal(nil, @planet.alias)
	
	@planet.alias = "Zim's Playground"
	
	assert_equal("Zim's Playground", @planet.alias)
  end
  
  def test_error_occurs_and_planet_alias_does_not_change_when_planet_alias_is_set_to_invalid_value
	assert_equal(nil, @planet.alias)
	
	# Should fail because it's not a string.
	assert_raise ArgumentError do
	  @planet.alias = (1236423254)
	end
	
	assert_equal(nil, @planet.alias)
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
	@planet.alias = "Zim's Playground"
	
	@planet.abandon
	
	assert_equal(0, @planet.num_buildings)
	assert_equal(0, @planet.buildings.count)
	
	assert_equal("Uncolonized", @planet.type)
	assert_equal(nil, @planet.name)
	assert_equal(nil, @planet.alias)
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
  
  def test_planet_notifies_observers_when_its_alias_changes
	@planet.add_observer(self)
	
	@planet.alias = "Zim's Playground"
	
	assert_true(@was_notified_of_change)
	
	@planet.delete_observer(self)
  end
  
  def test_planet_does_not_notify_observers_when_its_alias_is_set_to_identical_value
	@planet.alias = "Zim's Playground"
	
	@planet.add_observer(self)
	
	@planet.alias = "Zim's Playground"
	
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
	@planet.alias = "Zim's Playground"
	
	@planet.add_observer(self)
	
	@planet.abandon
	
	assert_true(@was_notified_of_change)
	
	@planet.delete_observer(self)
  end
end