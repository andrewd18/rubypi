require "test/unit"

require_relative "../model/launch_can.rb"

class TestCaseLaunchCan < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@building = LaunchCan.new
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_powergrid_usage_value
	assert_equal(0, @building.powergrid_usage)
  end
  
  def test_cpu_usage_value
	assert_equal(0, @building.cpu_usage)
  end
  
  def test_powergrid_provided_value
	assert_equal(0, @building.powergrid_provided)
  end
  
  def test_cpu_provided_value
	assert_equal(0, @building.cpu_provided)
  end
  
  def test_isk_cost_value
	assert_equal(0.00, @building.isk_cost)
  end
  
  def test_name
	assert_equal("Launch Can", @building.name)
  end
  
  def test_storage_volume
	assert_equal(500.0, @building.storage_volume)
  end
end