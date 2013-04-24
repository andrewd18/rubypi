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
  
  def test_powergrid_usage_scales_with_number_of_buildings
	pend()
  end
  
  def test_cpu_usage_scales_with_number_of_buildings
	pend()
  end
  
  def test_powergrid_provided_scales_with_number_of_buildings
	pend()
  end
  
  def test_cpu_provided_scales_with_number_of_buildings
	pend()
  end
  
  def test_isk_cost_scales_with_number_of_buildings
	pend()
  end
  
  def test_number_of_command_centers_scales_with_number_of_command_centers
	pend()
  end
  
  def test_number_of_factories_scales_with_number_of_command_centers
	pend()
  end
  
  def test_number_of_factories_scales_with_number_of_factories
	pend()
  end
  
  def test_number_of_launchpads_scales_with_number_of_launchpads
	pend()
  end
  
  def test_number_of_storage_facilities_scales_with_number_of_storage_facilities
	pend()
  end
  
  def test_aggregate_launchpads_ccs_storages_scales_with_launchpads_ccs_and_storages
	pend()
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
	pend()
  end
  
  def test_planet_does_not_notify_observers_when_its_type_is_set_to_identical_value
	pend()
  end
  
  def test_planet_notifies_observers_when_its_name_changes
	pend()
  end
  
  def test_planet_does_not_notify_observers_when_its_name_is_set_to_identical_value
	pend()
  end
  
  def test_planet_notifies_observers_when_its_alias_changes
	pend()
  end
  
  def test_planet_does_not_notify_observers_when_its_alias_is_set_to_identical_value
	pend()
  end
  
  def test_planet_notifies_observers_when_it_adds_a_building
	pend()
  end
  
  def test_planet_notifies_observers_when_it_removes_a_building
	pend()
  end
  
  def test_planet_notifies_observers_when_it_removes_all_buildings
	pend()
  end
end