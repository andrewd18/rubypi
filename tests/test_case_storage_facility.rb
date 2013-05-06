require "test/unit"

require_relative "../model/storage_facility.rb"

class TestCaseStorageFacility < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@building = StorageFacility.new
  end
  
  # Run after every test.
  def teardown
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
  
  def test_storage_volume
	assert_equal(12000.0, @building.storage_volume)
  end
  
  # Unrestricted Storage & Observer tests.
  
  def test_storage_facility_notifies_observers_on_store_product
	pend
  end
  
  def test_storage_facility_does_not_notify_observers_if_store_product_fails
	pend
  end
  
  def test_storage_facility_notifies_observers_on_store_product_instance
	pend
  end
  
  def test_storage_facility_does_not_notify_observers_if_store_product_instance_fails
	pend
  end
  
  def test_storage_facility_notifies_observers_on_product_remove_all
	pend
  end
  
  def test_storage_facility_does_not_notify_observers_if_product_remove_all_fails
	pend
  end
  
  def test_storage_facility_notifies_observers_on_product_remove_quantity
	pend
  end
  
  def test_storage_facility_does_not_notify_observers_if_product_remove_quantity_fails
	pend
  end
end