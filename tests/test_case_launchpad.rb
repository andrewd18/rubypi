require "test/unit"

require_relative "../model/launchpad.rb"

class TestCaseLaunchpad < Test::Unit::TestCase
  # Run once.
  def self.startup
	@@musk_ox = Product.find_or_create("Musk Ox", 0)
	@@covered_wagon = Product.find_or_create("Covered Wagon", 1)
  end
  
  # Run once after all tests.
  def self.shutdown
	Product.delete(@@musk_ox)
	Product.delete(@@covered_wagon)
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
  
  def test_launchpad_can_store_any_product_regardless_of_p_level # unlike a factory
	hash_with_musk_ox_and_covered_wagon = {"Musk Ox" => 9999, "Covered Wagon" => 1}
	
	@building.store_product("Musk Ox", 9999)
	@building.store_product("Covered Wagon", 1)
	
	assert_equal(hash_with_musk_ox_and_covered_wagon, @building.stored_products)
  end
  
  def test_launchpad_can_store_any_amount_of_a_given_product_within_max_volume # unlike a factory
	# This is the max number of P0s you can put in a launchpad.
	hash_with_one_million_musk_ox = {"Musk Ox" => 1000000}
	
	@building.store_product("Musk Ox", 1000000)
	
	assert_equal(hash_with_one_million_musk_ox, @building.stored_products)
  end
  
  def test_launchpad_can_add_a_certain_amount_of_a_specific_product_to_its_stores
	hash_with_5_musk_ox = {"Musk Ox" => 5}
	
	@building.store_product("Musk Ox", 5)
	
	assert_equal(hash_with_5_musk_ox, @building.stored_products)
  end
  
  def test_launchpad_stacks_products_if_you_add_more
	hash_with_5_musk_ox = {"Musk Ox" => 5}
	hash_with_20_musk_ox = {"Musk Ox" => 20}
	
	@building.store_product("Musk Ox", 5)
	
	assert_equal(hash_with_5_musk_ox, @building.stored_products)
	
	# Add 15 more.
	@building.store_product("Musk Ox", 15)
	
	assert_equal(hash_with_20_musk_ox, @building.stored_products)
  end
  
  def test_error_when_adding_a_product_and_first_arg_is_not_a_string
	assert_raise do
	  @building.store_product(@@musk_ox, 5)
	end
	
	# Make sure the launchpad didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_error_when_adding_a_product_and_first_arg_is_not_a_registered_product
	assert_raise do
	  @building.store_product("Macaque", 5)
	end
	
	# Make sure the launchpad didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_error_when_adding_a_product_and_second_arg_is_not_a_number
	assert_raise do
	  @building.store_product("Musk Ox", "Musk Ox")
	end
	
	# Make sure the launchpad didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_launchpad_can_add_a_certain_amount_of_a_specific_product_to_its_stores_by_product_instance
	@building.store_product_instance(@@musk_ox, 5)
	
	hash_with_5_musk_ox = {"Musk Ox" => 5}
	
	assert_equal(hash_with_5_musk_ox, @building.stored_products)
  end
  
  def test_launchpad_stacks_products_if_you_add_more_by_instance
	hash_with_5_musk_ox = {"Musk Ox" => 5}
	hash_with_20_musk_ox = {"Musk Ox" => 20}
	
	@building.store_product_instance(@@musk_ox, 5)
	
	assert_equal(hash_with_5_musk_ox, @building.stored_products)
	
	# Add 15 more.
	@building.store_product_instance(@@musk_ox, 15)
	
	assert_equal(hash_with_20_musk_ox, @building.stored_products)
  end
  
  def test_error_when_adding_a_product_by_instance_and_first_arg_is_not_a_product
	assert_raise do
	  @building.store_product_instance("Musk Ox", 5)
	end
	
	# Make sure the launchpad didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_error_when_adding_a_product_by_instance_and_second_arg_is_not_a_number
	assert_raise do
	  @building.store_product_instance(@@musk_ox, "Musk Ox")
	end
	
	# Make sure the launchpad didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_launchpad_can_remove_all_of_a_specific_product_from_its_stores
	@building.store_product("Musk Ox", 5)
	
	hash_with_5_musk_ox = {"Musk Ox" => 5}
	empty_hash = {}
	
	assert_equal(hash_with_5_musk_ox, @building.stored_products)
	
	@building.remove_all_of_product("Musk Ox")
	
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_launchpad_can_remove_a_certain_amount_of_a_specific_product_from_its_stores
	@building.store_product("Musk Ox", 5)
	
	hash_with_5_musk_ox = {"Musk Ox" => 5}
	hash_with_3_musk_ox = {"Musk Ox" => 3}
	
	assert_equal(hash_with_5_musk_ox, @building.stored_products)
	
	@building.remove_qty_of_product("Musk Ox", 2)
	
	assert_equal(hash_with_3_musk_ox, @building.stored_products)
  end
  
  def test_launchpad_errors_if_adding_a_product_would_overflow_it
	# This is the max number of P0s you can put in a launchpad.
	hash_with_one_million_musk_ox = {"Musk Ox" => 1000000}
	
	@building.store_product("Musk Ox", 1000000)
	assert_equal(0.0, @building.volume_available)
	
	assert_equal(hash_with_one_million_musk_ox, @building.stored_products)
	
	# Even one more Musk Ox would overflow it. Make sure it errors.
	assert_raise do
	  @building.store_product("Musk Ox", 1)
	end
	
	# Make sure storage doesn't change.
	assert_equal(hash_with_one_million_musk_ox, @building.stored_products)
	
	# An Covered Wagon (P1), being larger than a Musk Ox (P0) obviously should overflow too.
	assert_raise do
	  @building.store_product("Covered Wagon", 1)
	end
	
	# Make sure storage doesn't change.
	assert_equal(hash_with_one_million_musk_ox, @building.stored_products)
  end
  
  def test_launchpad_errors_if_removing_a_product_that_doesnt_exist
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
	
	assert_raise do
	  @building.remove_all_of_product("Musk Ox")
	end
	
	assert_equal(empty_hash, @building.stored_products)
	
	assert_raise do
	  @building.remove_qty_of_product("Musk Ox", 2)
	end
	
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_launchpad_removes_product_completely_if_more_than_value_is_removed
	hash_with_5_musk_ox = {"Musk Ox" => 5}
	empty_hash = {}
	
	assert_equal(empty_hash, @building.stored_products)
	
	@building.store_product("Musk Ox", 5)
	
	assert_equal(hash_with_5_musk_ox, @building.stored_products)
	
	# Remove more musk ox than we have.
	@building.remove_qty_of_product("Musk Ox", 20)
	
	# Shouldn't be at -15 musk ox.
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_launchpad_can_show_total_volume
	# Default
	assert_equal(10000.0, @building.total_volume)
	
	# After adding a product.
	@building.store_product("Musk Ox", 1)
	assert_equal(10000.0, @building.total_volume)
	
	# After adding second, different p-level product.
	@building.store_product("Covered Wagon", 1)
	assert_equal(10000.0, @building.total_volume)
  end
  
  def test_launchpad_can_show_volume_available
	# Default
	assert_equal(10000.0, @building.volume_available)
	
	# After adding a product.
	# P-level 0 products should take up 0.01 per unit.
	@building.store_product("Musk Ox", 1)
	assert_equal(9999.99, @building.volume_available)
	
	# After adding second, different p-level product.
	# P-level 1 products should take up 0.38 per unit.
	@building.store_product("Covered Wagon", 1)
	assert_equal(9999.61, @building.volume_available)
  end
  
  def test_launchpad_can_show_volume_used
	# Default
	assert_equal(0.0, @building.volume_used)
	
	# After adding a product.
	# P-level 0 products should take up 0.01 per unit.
	@building.store_product("Musk Ox", 1)
	assert_equal(0.01, @building.volume_used)
	
	# After adding second, different p-level product.
	# P-level 1 products should take up 0.38 per unit.
	@building.store_product("Covered Wagon", 1)
	assert_equal(0.39, @building.volume_used)
  end
end