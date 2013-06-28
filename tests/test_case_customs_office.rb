require "test/unit"

require_relative "../model/customs_office.rb"

class TestCaseCustomsOffice < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@building = CustomsOffice.new
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
	assert_equal("Customs Office", @building.name)
  end
  
  def test_storage_volume
	assert_equal(35000.0, @building.storage_volume)
  end
  
  def test_default_tax_rate_is_fifteen_percent
	assert_equal(15, @building.tax_rate)
  end
  
  def test_can_set_tax_rate
	assert_equal(15, @building.tax_rate)
	
	@building.tax_rate = 10
	
	assert_equal(10, @building.tax_rate)
  end
  
  def test_cannot_set_tax_rate_below_zero
	assert_equal(15, @building.tax_rate)
	
	assert_raise ArgumentError do
	  @building.tax_rate = (-30)
	end
	
	# Nothing should have changed from default.
	assert_equal(15, @building.tax_rate)
  end
  
  def test_cannot_set_tax_rate_above_one_hundred
	assert_raise ArgumentError do
	  @building.tax_rate = 35000
	end
	
	# Nothing should have changed from default.
	assert_equal(15, @building.tax_rate)
  end
  
  def test_cannot_set_tax_rate_to_non_number
	assert_raise ArgumentError do
	  @building.tax_rate = "faaaail"
	end
	
	# Nothing should have changed from default.
	assert_equal(15, @building.tax_rate)
  end
end