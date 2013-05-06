require "test/unit"

require_relative "../model/launchpad.rb"

class TestCaseLaunchpad < Test::Unit::TestCase
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
	hash_with_dwarves_and_ancient_beast = {"Dwarf" => 9999, "Ancient Beast" => 1}
	
	@building.store_product("Dwarf", 9999)
	@building.store_product("Ancient Beast", 1)
	
	assert_equal(hash_with_dwarves_and_ancient_beast, @building.stored_products)
  end
  
  def test_launchpad_can_store_any_amount_of_a_given_product_within_max_volume # unlike a factory
	# This is the max number of P0s you can put in a launchpad.
	hash_with_one_million_dwarves = {"Dwarf" => 1000000}
	
	@building.store_product("Dwarf", 1000000)
	
	assert_equal(hash_with_one_million_dwarves, @building.stored_products)
  end
  
  def test_launchpad_can_add_a_certain_amount_of_a_specific_product_to_its_stores
	hash_with_5_dwarves = {"Dwarf" => 5}
	
	@building.store_product("Dwarf", 5)
	
	assert_equal(hash_with_5_dwarves, @building.stored_products)
  end
  
  def test_launchpad_stacks_products_if_you_add_more
	hash_with_5_dwarves = {"Dwarf" => 5}
	hash_with_20_dwarves = {"Dwarf" => 20}
	
	@building.store_product("Dwarf", 5)
	
	assert_equal(hash_with_5_dwarves, @building.stored_products)
	
	# Add 15 more.
	@building.store_product("Dwarf", 15)
	
	assert_equal(hash_with_20_dwarves, @building.stored_products)
  end
  
  def test_error_when_adding_a_product_and_first_arg_is_not_a_string
	assert_raise do
	  @building.store_product(@@dwarf, 5)
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
	  @building.store_product("Dwarf", "Hammerdwarf")
	end
	
	# Make sure the launchpad didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_launchpad_can_add_a_certain_amount_of_a_specific_product_to_its_stores_by_product_instance
	@building.store_product_instance(@@dwarf, 5)
	
	hash_with_dwarf = {"Dwarf" => 5}
	
	assert_equal(hash_with_dwarf, @building.stored_products)
  end
  
  def test_launchpad_stacks_products_if_you_add_more_by_instance
	hash_with_5_dwarves = {"Dwarf" => 5}
	hash_with_20_dwarves = {"Dwarf" => 20}
	
	@building.store_product_instance(@@dwarf, 5)
	
	assert_equal(hash_with_5_dwarves, @building.stored_products)
	
	# Add 15 more.
	@building.store_product_instance(@@dwarf, 15)
	
	assert_equal(hash_with_20_dwarves, @building.stored_products)
  end
  
  def test_error_when_adding_a_product_by_instance_and_first_arg_is_not_a_product
	assert_raise do
	  @building.store_product_instance("Dwarf", 5)
	end
	
	# Make sure the launchpad didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_error_when_adding_a_product_by_instance_and_second_arg_is_not_a_number
	assert_raise do
	  @building.store_product_instance(@@dwarf, "Hammerdwarf")
	end
	
	# Make sure the launchpad didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_launchpad_can_remove_all_of_a_specific_product_from_its_stores
	@building.store_product("Dwarf", 5)
	
	hash_with_dwarf = {"Dwarf" => 5}
	empty_hash = {}
	
	assert_equal(hash_with_dwarf, @building.stored_products)
	
	@building.remove_all_of_product("Dwarf")
	
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_launchpad_can_remove_a_certain_amount_of_a_specific_product_from_its_stores
	@building.store_product("Dwarf", 5)
	
	hash_with_5_dwarves = {"Dwarf" => 5}
	hash_with_3_dwarves = {"Dwarf" => 3}
	
	assert_equal(hash_with_5_dwarves, @building.stored_products)
	
	@building.remove_qty_of_product("Dwarf", 2)
	
	assert_equal(hash_with_3_dwarves, @building.stored_products)
  end
  
  def test_launchpad_errors_if_adding_a_product_would_overflow_it
	# This is the max number of P0s you can put in a launchpad.
	hash_with_one_million_dwarves = {"Dwarf" => 1000000}
	
	@building.store_product("Dwarf", 1000000)
	assert_equal(0.0, @building.volume_available)
	
	assert_equal(hash_with_one_million_dwarves, @building.stored_products)
	
	# Even one more dwarf would overflow it. Make sure it errors.
	assert_raise do
	  @building.store_product("Dwarf", 1)
	end
	
	# Make sure launchpad doesn't change.
	assert_equal(hash_with_one_million_dwarves, @building.stored_products)
	
	# An Ancient Beast (P1), being larger than a dwarf (P0) obviously should overflow too.
	assert_raise do
	  @building.store_product("Ancient Beast", 1)
	end
	
	# Make sure launchpad doesn't change.
	assert_equal(hash_with_one_million_dwarves, @building.stored_products)
  end
  
  def test_launchpad_errors_if_removing_a_product_that_doesnt_exist
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
	
	assert_raise do
	  @building.remove_all_of_product("Dwarf")
	end
	
	assert_equal(empty_hash, @building.stored_products)
	
	assert_raise do
	  @building.remove_qty_of_product("Dwarf", 2)
	end
	
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_launchpad_removes_product_completely_if_more_than_value_is_removed
	hash_with_5_dwarves = {"Dwarf" => 5}
	empty_hash = {}
	
	assert_equal(empty_hash, @building.stored_products)
	
	@building.store_product("Dwarf", 5)
	
	assert_equal(hash_with_5_dwarves, @building.stored_products)
	
	# Remove more dwarves than we have.
	@building.remove_qty_of_product("Dwarf", 20)
	
	# Shouldn't be at -15 dwarves.
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_launchpad_can_show_total_volume
	# Default
	assert_equal(10000.0, @building.total_volume)
	
	# After adding a product.
	@building.store_product("Dwarf", 1)
	assert_equal(10000.0, @building.total_volume)
	
	# After adding second, different p-level product.
	@building.store_product("Ancient Beast", 1)
	assert_equal(10000.0, @building.total_volume)
  end
  
  def test_launchpad_can_show_volume_available
	# Default
	assert_equal(10000.0, @building.volume_available)
	
	# After adding a product.
	# P-level 0 products should take up 0.01 per unit.
	@building.store_product("Dwarf", 1)
	assert_equal(9999.99, @building.volume_available)
	
	# After adding second, different p-level product.
	# P-level 1 products should take up 0.38 per unit.
	@building.store_product("Ancient Beast", 1)
	assert_equal(9999.61, @building.volume_available)
  end
  
  def test_launchpad_can_show_volume_used
	# Default
	assert_equal(0.0, @building.volume_used)
	
	# After adding a product.
	# P-level 0 products should take up 0.01 per unit.
	@building.store_product("Dwarf", 1)
	assert_equal(0.01, @building.volume_used)
	
	# After adding second, different p-level product.
	# P-level 1 products should take up 0.38 per unit.
	@building.store_product("Ancient Beast", 1)
	assert_equal(0.39, @building.volume_used)
  end
end