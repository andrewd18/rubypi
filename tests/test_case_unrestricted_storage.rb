# test_case_unrestricted_storage

require "test/unit"
require "observer"
require_relative "../model/unrestricted_storage.rb"

class UnrestrictedStorageStub
  include Observable
  include UnrestrictedStorage
  
  def storage_volume
	return 500.0
  end
end

class NotObservableUnrestrictedStorageStub
  include UnrestrictedStorage
  
  def storage_volume
	return 500.0
  end
end

class TestCaseUnrestrictedStorage < Test::Unit::TestCase
  # Run once.
  def self.startup
	@@dwarf = Product.find_or_create("Dwarf", 0)
	@@ancient_beast = Product.find_or_create("Ancient Beast", 1)
  end
  
  # Run once after all tests.
  def self.shutdown
	Product.delete(@@dwarf)
	Product.delete(@@ancient_beast)
  end

  # Run before every test.
  def setup
	@building_stub = UnrestrictedStorageStub.new
	@was_notified_of_change = false
  end
  
  # Run after every test.
  def teardown
	
  end
  
  def test_building_can_store_any_product_regardless_of_p_level # unlike a factory
	hash_with_dwarves_and_ancient_beast = {"Dwarf" => 999, "Ancient Beast" => 1}
	
	@building_stub.store_product("Dwarf", 999)
	@building_stub.store_product("Ancient Beast", 1)
	
	assert_equal(hash_with_dwarves_and_ancient_beast, @building_stub.stored_products)
  end
  
  def test_building_can_store_any_amount_of_a_given_product_within_max_volume # unlike a factory
	# This is the max number of P0s you can put in a 500.0 m3 building.
	hash_with_50k_dwarves = {"Dwarf" => 50000}
	
	@building_stub.store_product("Dwarf", 50000)
	
	assert_equal(hash_with_50k_dwarves, @building_stub.stored_products)
  end
  
  def test_building_can_add_a_certain_amount_of_a_specific_product_to_its_stores
	hash_with_5_dwarves = {"Dwarf" => 5}
	
	@building_stub.store_product("Dwarf", 5)
	
	assert_equal(hash_with_5_dwarves, @building_stub.stored_products)
  end
  
  def test_building_stacks_products_if_you_add_more
	hash_with_5_dwarves = {"Dwarf" => 5}
	hash_with_20_dwarves = {"Dwarf" => 20}
	
	@building_stub.store_product("Dwarf", 5)
	
	assert_equal(hash_with_5_dwarves, @building_stub.stored_products)
	
	# Add 15 more.
	@building_stub.store_product("Dwarf", 15)
	
	assert_equal(hash_with_20_dwarves, @building_stub.stored_products)
  end
  
  def test_error_when_adding_a_product_and_first_arg_is_not_a_string
	assert_raise do
	  @building_stub.store_product(@@dwarf, 5)
	end
	
	# Make sure the building didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building_stub.stored_products)
  end
  
  def test_error_when_adding_a_product_and_first_arg_is_not_a_registered_product
	assert_raise do
	  @building_stub.store_product("Macaque", 5)
	end
	
	# Make sure the building didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building_stub.stored_products)
  end
  
  def test_error_when_adding_a_product_and_second_arg_is_not_a_number
	assert_raise do
	  @building_stub.store_product("Dwarf", "Hammerdwarf")
	end
	
	# Make sure the building didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building_stub.stored_products)
  end
  
  def test_error_when_adding_a_quantity_of_zero_or_less
	assert_raise ArgumentError do
	  @building_stub.store_product("Dwarf", 0)
	end
	
	assert_raise ArgumentError do
	  @building_stub.store_product("Dwarf", -30)
	end
	
	# Make sure the building didn't change.
	# I don't even want {Dwarf => 0}
	empty_hash = {}
	assert_equal(empty_hash, @building_stub.stored_products)
  end
  
  def test_building_can_add_a_certain_amount_of_a_specific_product_to_its_stores_by_product_instance
	@building_stub.store_product_instance(@@dwarf, 5)
	
	hash_with_dwarf = {"Dwarf" => 5}
	
	assert_equal(hash_with_dwarf, @building_stub.stored_products)
  end
  
  def test_building_stacks_products_if_you_add_more_by_instance
	hash_with_5_dwarves = {"Dwarf" => 5}
	hash_with_20_dwarves = {"Dwarf" => 20}
	
	@building_stub.store_product_instance(@@dwarf, 5)
	
	assert_equal(hash_with_5_dwarves, @building_stub.stored_products)
	
	# Add 15 more.
	@building_stub.store_product_instance(@@dwarf, 15)
	
	assert_equal(hash_with_20_dwarves, @building_stub.stored_products)
  end
  
  def test_error_when_adding_a_product_by_instance_and_first_arg_is_not_a_product
	assert_raise do
	  @building_stub.store_product_instance("Dwarf", 5)
	end
	
	# Make sure the building didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building_stub.stored_products)
  end
  
  def test_error_when_adding_a_product_by_instance_and_second_arg_is_not_a_number
	assert_raise do
	  @building_stub.store_product_instance(@@dwarf, "Hammerdwarf")
	end
	
	# Make sure the building didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building_stub.stored_products)
  end
  
  def test_error_when_adding_a_product_by_instance_and_quantity_is_zero_or_less
	assert_raise ArgumentError do
	  @building_stub.store_product_instance(@@dwarf, 0)
	end
	
	assert_raise ArgumentError do
	  @building_stub.store_product_instance(@@dwarf, -30)
	end
	
	# Make sure the building didn't change.
	# I don't even want {Dwarf => 0}
	empty_hash = {}
	assert_equal(empty_hash, @building_stub.stored_products)
  end
  
  def test_building_can_remove_all_of_a_specific_product_from_its_stores
	@building_stub.store_product("Dwarf", 5)
	
	hash_with_dwarf = {"Dwarf" => 5}
	empty_hash = {}
	
	assert_equal(hash_with_dwarf, @building_stub.stored_products)
	
	@building_stub.remove_all_of_product("Dwarf")
	
	assert_equal(empty_hash, @building_stub.stored_products)
  end
  
  def test_building_can_remove_a_certain_amount_of_a_specific_product_from_its_stores
	@building_stub.store_product("Dwarf", 5)
	
	hash_with_5_dwarves = {"Dwarf" => 5}
	hash_with_3_dwarves = {"Dwarf" => 3}
	
	assert_equal(hash_with_5_dwarves, @building_stub.stored_products)
	
	@building_stub.remove_qty_of_product("Dwarf", 2)
	
	assert_equal(hash_with_3_dwarves, @building_stub.stored_products)
  end
  
  def test_building_errors_if_adding_a_product_would_overflow_it
	# This is the max number of P0s you can put in a 500.0 m3 building.
	hash_with_50k_dwarves = {"Dwarf" => 50000}
	
	@building_stub.store_product("Dwarf", 50000)
	assert_equal(0.0, @building_stub.volume_available)
	
	assert_equal(hash_with_50k_dwarves, @building_stub.stored_products)
	
	# Even one more dwarf would overflow it. Make sure it errors.
	assert_raise do
	  @building_stub.store_product("Dwarf", 1)
	end
	
	# Make sure building doesn't change.
	assert_equal(hash_with_50k_dwarves, @building_stub.stored_products)
	
	# An Ancient Beast (P1), being larger than a dwarf (P0) obviously should overflow too.
	assert_raise do
	  @building_stub.store_product("Ancient Beast", 1)
	end
	
	# Make sure building doesn't change.
	assert_equal(hash_with_50k_dwarves, @building_stub.stored_products)
  end
  
  def test_building_errors_if_removing_a_product_that_doesnt_exist
	empty_hash = {}
	assert_equal(empty_hash, @building_stub.stored_products)
	
	assert_raise do
	  @building_stub.remove_all_of_product("Dwarf")
	end
	
	assert_equal(empty_hash, @building_stub.stored_products)
	
	assert_raise do
	  @building_stub.remove_qty_of_product("Dwarf", 2)
	end
	
	assert_equal(empty_hash, @building_stub.stored_products)
  end
  
  def test_building_removes_product_completely_if_more_than_value_is_removed
	hash_with_5_dwarves = {"Dwarf" => 5}
	empty_hash = {}
	
	assert_equal(empty_hash, @building_stub.stored_products)
	
	@building_stub.store_product("Dwarf", 5)
	
	assert_equal(hash_with_5_dwarves, @building_stub.stored_products)
	
	# Remove more dwarves than we have.
	@building_stub.remove_qty_of_product("Dwarf", 20)
	
	# Shouldn't be at -15 dwarves.
	assert_equal(empty_hash, @building_stub.stored_products)
  end
  
  def test_error_when_removing_a_quantity_of_zero_or_less
	hash_with_5_dwarves = {"Dwarf" => 5}
	empty_hash = {}
	
	assert_equal(empty_hash, @building_stub.stored_products)
	
	@building_stub.store_product("Dwarf", 5)
	
	assert_equal(hash_with_5_dwarves, @building_stub.stored_products)
	
	assert_raise ArgumentError do
	  @building_stub.remove_qty_of_product("Dwarf", 0)
	end
	
	assert_raise ArgumentError do
	  @building_stub.remove_qty_of_product("Dwarf", -30)
	end
	
	# Nothing should have happened.
	assert_equal(hash_with_5_dwarves, @building_stub.stored_products)
  end
  
  def test_can_replace_stored_products_with_new_hash
	hash_with_5_dwarves = {"Dwarf" => 5}
	empty_hash = {}
	
	assert_equal(empty_hash, @building_stub.stored_products)
	
	@building_stub.stored_products = hash_with_5_dwarves
	
	assert_equal(hash_with_5_dwarves, @building_stub.stored_products)
  end
  
  def test_cannot_replace_stored_products_with_a_non_hash
	empty_hash = {}
	
	assert_equal(empty_hash, @building_stub.stored_products)
	
	assert_raise ArgumentError do
	  @building_stub.stored_products = "Forgotten Beast"
	end
	
	assert_raise ArgumentError do
	  @building_stub.stored_products = 1.0
	end
	
	assert_raise ArgumentError do
	  @building_stub.stored_products = ["Forgotten Beast", 1.0]
	end
	
	assert_equal(empty_hash, @building_stub.stored_products)
  end
  
  def test_building_can_show_total_volume
	# Default
	assert_equal(500.0, @building_stub.total_volume)
	
	# After adding a product.
	@building_stub.store_product("Dwarf", 1)
	assert_equal(500.0, @building_stub.total_volume)
	
	# After adding second, different p-level product.
	@building_stub.store_product("Ancient Beast", 1)
	assert_equal(500.0, @building_stub.total_volume)
  end
  
  def test_building_can_show_volume_available
	# Default
	assert_equal(500.0, @building_stub.volume_available)
	
	# After adding a product.
	# P-level 0 products should take up 0.01 per unit.
	@building_stub.store_product("Dwarf", 1)
	assert_equal(499.99, @building_stub.volume_available)
	
	# After adding second, different p-level product.
	# P-level 1 products should take up 0.38 per unit.
	@building_stub.store_product("Ancient Beast", 1)
	assert_equal(499.61, @building_stub.volume_available)
  end
  
  def test_building_can_show_volume_used
	# Default
	assert_equal(0.0, @building_stub.volume_used)
	
	# After adding a product.
	# P-level 0 products should take up 0.01 per unit.
	@building_stub.store_product("Dwarf", 1)
	assert_equal(0.01, @building_stub.volume_used)
	
	# After adding second, different p-level product.
	# P-level 1 products should take up 0.38 per unit.
	@building_stub.store_product("Ancient Beast", 1)
	assert_equal(0.39, @building_stub.volume_used)
  end
  
  def test_building_can_show_volume_pct_used
	# Should return 0 percent used when empty.
	assert_equal(0.0, @building_stub.pct_volume_used)
	
	# After storing 3000 dwarves, we've used 30m3 out of 500m3 volume.
	@building_stub.store_product("Dwarf", 3000)
	assert_equal(30.00, @building_stub.volume_used)
	
	# algorithm = ((@building_stub.storage_volume / 100) * @building_stub.volume_used)
	# percent = ((500 / 100) * 30)
	assert_equal(6.0, @building_stub.pct_volume_used)
	
	# Add one more dwarf and recheck.
	@building_stub.store_product("Dwarf", 1)
	assert_equal(30.01, @building_stub.volume_used)
	
	# percent = ((500 / 100) * 30)
	
	# Test that we round to 2 decimal places.
	# Normally this would be 6.002000000000001
	# But we check for 6.00
	assert_equal(6.00, @building_stub.pct_volume_used)
  end
    
  
  # Observer interaction tests.
  
  def test_unrestricted_storage_stub_is_observable
	assert_true(@building_stub.is_a?(Observable), "UnrestrictedStorageStub did not include Observable.")
  end
  
  def test_non_observable_unrestricted_storage_stub_is_not_observable
	@building_stub = NotObservableUnrestrictedStorageStub.new
	assert_false(@building_stub.is_a?(Observable), "NotObservableUnrestrictedStorageStub did include Observable.")
  end
  
  # Update method for testing observer.
  def update
	@was_notified_of_change = true
  end
  
  def test_building_notifies_observers_on_store_product
	assert_false(@was_notified_of_change)
	@building_stub.add_observer(self)
	
	@building_stub.store_product("Dwarf", 1)
	assert_true(@was_notified_of_change)
	
	@building_stub.delete_observer(self)
  end
  
  def test_building_does_not_notify_observers_if_store_product_fails
	assert_false(@was_notified_of_change)
	@building_stub.add_observer(self)
	
	# Invalid product name.
	assert_raise do
	  @building_stub.store_product(@@dwarf, 1)
	end
	assert_false(@was_notified_of_change)
	
	# Invalid quantity.
	assert_raise do
	  @building_stub.store_product("Dwarf", "Fail")
	end
	assert_false(@was_notified_of_change)
	
	# Too many products.
	assert_raise do
	  @building_stub.store_product("Dwarf", 99999999999999999)
	end
	assert_false(@was_notified_of_change)
	
	# Adding zero quantity.
	assert_raise do
	  @building_stub.store_product("Dwarf", 0)
	end
	assert_false(@was_notified_of_change)
	
	# Adding negative quantity.
	assert_raise do
	  @building_stub.store_product("Dwarf", -30)
	end
	assert_false(@was_notified_of_change)
	
	@building_stub.delete_observer(self)
  end
  
  def test_building_notifies_observers_on_store_product_instance
	assert_false(@was_notified_of_change)
	@building_stub.add_observer(self)
	
	@building_stub.store_product_instance(@@dwarf, 1)
	assert_true(@was_notified_of_change)
	
	@building_stub.delete_observer(self)
  end
  
  def test_building_does_not_notify_observers_if_store_product_instance_fails
	assert_false(@was_notified_of_change)
	@building_stub.add_observer(self)
	
	# Invalid product instance.
	assert_raise do
	  @building_stub.store_product_instance("Dwarf", 1)
	end
	assert_false(@was_notified_of_change)
	
	# Invalid quantity.
	assert_raise do
	  @building_stub.store_product_instance(@@dwarf, "Fail")
	end
	assert_false(@was_notified_of_change)
	
	# Too many products.
	assert_raise do
	  @building_stub.store_product_instance(@@dwarf, 99999999999999999)
	end
	assert_false(@was_notified_of_change)
	
	# Adding zero quantity.
	assert_raise do
	  @building_stub.store_product_instance(@@dwarf, 0)
	end
	assert_false(@was_notified_of_change)
	
	# Adding negative quantity.
	assert_raise do
	  @building_stub.store_product_instance(@@dwarf, -30)
	end
	assert_false(@was_notified_of_change)
	
	@building_stub.delete_observer(self)
  end
  
  def test_building_notifies_observers_on_product_remove_all
	assert_false(@was_notified_of_change)
	@building_stub.store_product("Dwarf", 10)
	
	@building_stub.add_observer(self)
	
	@building_stub.remove_all_of_product("Dwarf")
	assert_true(@was_notified_of_change)
	
	@building_stub.delete_observer(self)
  end
  
  def test_building_does_not_notify_observers_if_product_remove_all_fails
	assert_false(@was_notified_of_change)
	@building_stub.store_product("Dwarf", 10)
	
	@building_stub.add_observer(self)
	
	assert_raise do
	  @building_stub.remove_all_of_product("Ancient Beast")
	end
	assert_false(@was_notified_of_change)
	
	@building_stub.delete_observer(self)
  end
  
  def test_building_notifies_observers_on_product_remove_quantity
	assert_false(@was_notified_of_change)
	@building_stub.store_product("Dwarf", 10)
	
	@building_stub.add_observer(self)
	
	@building_stub.remove_qty_of_product("Dwarf", 5)
	assert_true(@was_notified_of_change)
	
	@building_stub.delete_observer(self)
  end
  
  def test_building_does_not_notify_observers_if_product_remove_quantity_fails
	assert_false(@was_notified_of_change)
	@building_stub.store_product("Dwarf", 10)
	
	@building_stub.add_observer(self)
	
	assert_raise do
	  @building_stub.remove_qty_of_product("Ancient Beast", 5)
	end
	assert_false(@was_notified_of_change)
	
	# Removing zero quantity.
	assert_raise do
	  @building_stub.remove_qty_of_product("Dwarf", 0)
	end
	assert_false(@was_notified_of_change)
	
	# Removing negative quantity.
	assert_raise do
	  @building_stub.remove_qty_of_product("Dwarf", -30)
	end
	assert_false(@was_notified_of_change)
	
	@building_stub.delete_observer(self)
  end
  
  def test_building_that_is_not_observable_can_still_add_and_remove_products_without_error
	@building_stub = NotObservableUnrestrictedStorageStub.new
	
	assert_equal(0.0, @building_stub.volume_used)
	
	@building_stub.store_product("Dwarf", 1)
	assert_equal(0.01, @building_stub.volume_used)
	
	@building_stub.store_product("Ancient Beast", 1)
	assert_equal(0.39, @building_stub.volume_used)
	
	@building_stub.remove_all_of_product("Dwarf")
	assert_equal(0.38, @building_stub.volume_used)
	
	@building_stub.remove_qty_of_product("Ancient Beast", 1)
	assert_equal(0.0, @building_stub.volume_used)
  end
end