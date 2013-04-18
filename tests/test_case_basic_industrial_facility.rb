require "test/unit"

require_relative "../model/basic_industrial_facility.rb"

class TestCaseBasicIndustrialFacility < Test::Unit::TestCase
  def setup
	@building = BasicIndustrialFacility.new
	@was_notified_of_change = false
  end
  
  def teardown
	# nada
  end
  
  def test_powergrid_usage_value
	assert_equal(800, @building.powergrid_usage)
  end
  
  def test_cpu_usage_value
	assert_equal(200, @building.cpu_usage)
  end
  
  def test_powergrid_provided_value
	assert_equal(0, @building.powergrid_provided)
  end
  
  def test_cpu_provided_value
	assert_equal(0, @building.cpu_provided)
  end
  
  def test_isk_cost_value
	assert_equal(75000.00, @building.isk_cost)
  end
  
  def test_name
	assert_equal("Basic Industrial Facility", @building.name)
  end
  
  def test_set_schematic
	# TODO
	pend("Write test to make sure you can set a schematic.")
  end
  
  def test_facility_errors_if_schematic_is_not_acceptable
	# TODO
	pend("Write test to make sure setting an invalid schematic errors.")
  end
  
  def test_accepted_schematics
	# TODO
	pend("Write test to make sure accepted_schematics provides the right list.")
  end
  
  def test_remove_schematic
	# TODO
	pend("Write test to make sure you can remove a schematic.")
  end
  
  # 
  # "Observable" tests
  # 
  
  def test_basic_industrial_facility_is_observable
	assert_true(@building.is_a?(Observable), "Basic Industrial Facility did not include Observable.")
  end
  
  # Update method for testing observer.
  def update
	@was_notified_of_change = true
  end
  
  def test_facility_notifies_observers_on_schematic_set
	# TODO
	pend("Write test to verify that observers know when a schematic has been added.")
  end
  
  def test_facility_does_not_notify_observers_on_schematic_set_failure
	# TODO
	pend("Write test to verify that observers do not get notified when a schematic set fails.")
  end
  
  def test_facility_notifies_observers_on_schematic_removal
	# TODO
	pend("Write test to verify that observers know when a schematic has been removed.")
  end
end