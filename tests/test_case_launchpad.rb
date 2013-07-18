require "test/unit"

require_relative "../model/launchpad.rb"

class TestCaseLaunchpad < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@building = Launchpad.new
  end
  
  # Run once after every test.
  def teardown
  end
  
  def test_powergrid_usage_value
	assert_equal(700, @building.powergrid_usage)
  end
  
  def test_cpu_usage_value
	assert_equal(3600, @building.cpu_usage)
  end
  
  def test_powergrid_provided_value
	assert_equal(0, @building.powergrid_provided)
  end
  
  def test_cpu_provided_value
	assert_equal(0, @building.cpu_provided)
  end
  
  def test_isk_cost_value
	assert_equal(900000.00, @building.isk_cost)
  end
  
  def test_name
	assert_equal("Launchpad", @building.name)
  end
  
  def test_can_get_x_position
	# Default should be 0.0.
	assert_equal(0.0, @building.x_pos)
  end
  
  def test_can_set_x_position
	@building.x_pos = 1.5
	assert_equal(1.5, @building.x_pos)
  end
  
  def test_can_get_y_position
	# Default should be 0.0.
	assert_equal(0.0, @building.y_pos)
  end
  
  def test_can_set_y_position
	@building.y_pos = 3.2
	assert_equal(3.2, @building.y_pos)
  end
  
  def test_can_set_x_and_y_positions_in_constructor
	@building = Launchpad.new(1.5, 3.2)
	assert_equal(1.5, @building.x_pos)
	assert_equal(3.2, @building.y_pos)
  end
  
  def test_storage_volume
	assert_equal(10000.0, @building.storage_volume)
  end
end