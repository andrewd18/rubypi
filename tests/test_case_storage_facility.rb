require "test/unit"

require_relative "../model/storage_facility.rb"

class TestCaseStorageFacility < Test::Unit::TestCase
  def setup
	@building = StorageFacility.new
  end
  
  def teardown
	# nada
  end
  
  def test_powergrid_usage_value
	assert_equal(700, @building.powergrid_usage)
  end
  
  def test_cpu_usage_value
	assert_equal(500, @building.cpu_usage)
  end
  
  def test_powergrid_provided_value
	assert_equal(0, @building.powergrid_provided)
  end
  
  def test_cpu_provided_value
	assert_equal(0, @building.cpu_provided)
  end
  
  def test_isk_cost_value
	assert_equal(250000.00, @building.isk_cost)
  end
  
  def test_name
	assert_equal("Storage Facility", @building.name)
  end
end