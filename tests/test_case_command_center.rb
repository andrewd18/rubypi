require "test/unit"

require_relative "../model/command_center.rb"

class TestCaseCommandCenter < Test::Unit::TestCase
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
	@building = CommandCenter.new
	@was_notified_of_change = false
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_default_level_is_zero
	assert_equal(0, @building.upgrade_level, "Default command center level is not zero.")
  end
  
  def test_level_can_be_increased
	@building.increase_level
	assert_equal(1, @building.upgrade_level, "Increasing a command center level did not work.")
  end
  
  def test_level_can_be_decreased
	@building.increase_level # 1
	
	@building.decrease_level
	assert_equal(0, @building.upgrade_level, "Decreasing a command center level did not work.")
  end
  
  def test_level_can_be_set
	@building.set_level(3)
	assert_equal(3, @building.upgrade_level, "Setting a command center level did not work.")
  end
  
  def test_level_cannot_be_increased_above_five
	@building.set_level(5)
	
	# Attempt to increase to 6.
	@building.increase_level
	assert_equal(5, @building.upgrade_level, "Increasing upgrade level 6 times does not max out at level 5.")
  end
  
  def test_level_cannot_be_decreased_below_zero
	@building.decrease_level
	assert_equal(0, @building.upgrade_level, "Decreasing the upgrade level from zero does not stop at zero.")
  end
  
  def test_level_cannot_be_set_below_zero
	# Make sure the class raises an argument error.
	assert_raise ArgumentError do
	  @building.set_level(-1)
	end
	
	assert_raise ArgumentError do
	  @building.set_level(-12)
	end
	
	assert_raise ArgumentError do
	  @building.set_level(-1236423254)
	end
	
	# Make sure the value didn't change.
	assert_equal(0, @building.upgrade_level, "Level should not be able to be set below zero.")
  end
  
  def test_level_cannot_be_set_above_five
	# Make sure the class raises an argument error.
	assert_raise ArgumentError do
	  @building.set_level(6)
	end
	
	assert_raise ArgumentError do
	  @building.set_level(12)
	end
	
	assert_raise ArgumentError do
	  @building.set_level(1236423254)
	end
	
	assert_equal(0, @building.upgrade_level, "Level should not be able to be set above five.")
  end
  
  def test_powergrid_provided_scales_with_level
	# CC Level 0
	assert_equal(6000, @building.powergrid_provided, "Level 0 CC powergrid is not accurate.")
	
	@building.increase_level # 1
	assert_equal(9000, @building.powergrid_provided, "Level 1 CC powergrid is not accurate.")
	
	@building.increase_level # 2
	assert_equal(12000, @building.powergrid_provided, "Level 2 CC powergrid is not accurate.")
	
	@building.increase_level # 3
	assert_equal(15000, @building.powergrid_provided, "Level 3 CC powergrid is not accurate.")
	
	@building.increase_level # 4
	assert_equal(17000, @building.powergrid_provided, "Level 4 CC powergrid is not accurate.")
	
	@building.increase_level # 5
	assert_equal(19000, @building.powergrid_provided, "Level 5 CC powergrid is not accurate.")
  end
  
  def test_cpu_provided_scales_with_level
	# CC Level 0
	assert_equal(1675, @building.cpu_provided, "Level 0 CC cpu is not accurate.")
	
	@building.increase_level # 1
	assert_equal(7057, @building.cpu_provided, "Level 1 CC cpu is not accurate.")
	
	@building.increase_level # 2
	assert_equal(12136, @building.cpu_provided, "Level 2 CC cpu is not accurate.")
	
	@building.increase_level # 3
	assert_equal(17215, @building.cpu_provided, "Level 3 CC cpu is not accurate.")
	
	@building.increase_level # 4
	assert_equal(21315, @building.cpu_provided, "Level 4 CC cpu is not accurate.")
	
	@building.increase_level # 5
	assert_equal(25415, @building.cpu_provided, "Level 5 CC cpu is not accurate.")
  end
  
  def test_powergrid_usage_value
	assert_equal(0, @building.powergrid_usage)
  end
  
  def test_cpu_usage_value
	assert_equal(0, @building.cpu_usage)
  end
  
  def test_isk_cost_scales_with_level
	# CC Level 0
	assert_equal(90000.00, @building.isk_cost, "Level 0 CC isk cost is not accurate.")
	
	@building.increase_level # 1
	assert_equal(670000.00, @building.isk_cost, "Level 1 CC isk cost is not accurate.")
	
	@building.increase_level # 2
	assert_equal(1600000.00, @building.isk_cost, "Level 2 CC isk cost is not accurate.")
	
	@building.increase_level # 3
	assert_equal(2800000.00, @building.isk_cost, "Level 3 CC isk cost is not accurate.")
	
	@building.increase_level # 4
	assert_equal(4300000.00, @building.isk_cost, "Level 4 CC isk cost is not accurate.")
	
	@building.increase_level # 5
	assert_equal(6400000, @building.isk_cost, "Level 5 CC isk cost is not accurate.")
  end
  
  def test_name
	assert_equal("Command Center", @building.name)
  end
  
  #
  # Storage tests
  #
  
  
  def test_command_center_can_store_any_product_regardless_of_p_level # unlike a factory
	hash_with_dwarves_and_ancient_beast = {"Dwarf" => 999, "Ancient Beast" => 1}
	
	@building.store_product("Dwarf", 999)
	@building.store_product("Ancient Beast", 1)
	
	assert_equal(hash_with_dwarves_and_ancient_beast, @building.stored_products)
  end
  
  def test_command_center_can_store_any_amount_of_a_given_product_within_max_volume # unlike a factory
	# This is the max number of P0s you can put in a command center.
	hash_with_50k_dwarves = {"Dwarf" => 50000}
	
	@building.store_product("Dwarf", 50000)
	
	assert_equal(hash_with_50k_dwarves, @building.stored_products)
  end
  
  def test_command_center_can_add_a_certain_amount_of_a_specific_product_to_its_stores
	hash_with_5_dwarves = {"Dwarf" => 5}
	
	@building.store_product("Dwarf", 5)
	
	assert_equal(hash_with_5_dwarves, @building.stored_products)
  end
  
  def test_command_center_stacks_products_if_you_add_more
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
	
	# Make sure the command center didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_error_when_adding_a_product_and_first_arg_is_not_a_registered_product
	assert_raise do
	  @building.store_product("Macaque", 5)
	end
	
	# Make sure the command center didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_error_when_adding_a_product_and_second_arg_is_not_a_number
	assert_raise do
	  @building.store_product("Dwarf", "Hammerdwarf")
	end
	
	# Make sure the command center didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_command_center_can_add_a_certain_amount_of_a_specific_product_to_its_stores_by_product_instance
	@building.store_product_instance(@@dwarf, 5)
	
	hash_with_dwarf = {"Dwarf" => 5}
	
	assert_equal(hash_with_dwarf, @building.stored_products)
  end
  
  def test_command_center_stacks_products_if_you_add_more_by_instance
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
	
	# Make sure the command center didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_error_when_adding_a_product_by_instance_and_second_arg_is_not_a_number
	assert_raise do
	  @building.store_product_instance(@@dwarf, "Hammerdwarf")
	end
	
	# Make sure the command center didn't change.
	empty_hash = {}
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_command_center_can_remove_all_of_a_specific_product_from_its_stores
	@building.store_product("Dwarf", 5)
	
	hash_with_dwarf = {"Dwarf" => 5}
	empty_hash = {}
	
	assert_equal(hash_with_dwarf, @building.stored_products)
	
	@building.remove_all_of_product("Dwarf")
	
	assert_equal(empty_hash, @building.stored_products)
  end
  
  def test_command_center_can_remove_a_certain_amount_of_a_specific_product_from_its_stores
	@building.store_product("Dwarf", 5)
	
	hash_with_5_dwarves = {"Dwarf" => 5}
	hash_with_3_dwarves = {"Dwarf" => 3}
	
	assert_equal(hash_with_5_dwarves, @building.stored_products)
	
	@building.remove_qty_of_product("Dwarf", 2)
	
	assert_equal(hash_with_3_dwarves, @building.stored_products)
  end
  
  def test_command_center_errors_if_adding_a_product_would_overflow_it
	# This is the max number of P0s you can put in a command center.
	hash_with_50k_dwarves = {"Dwarf" => 50000}
	
	@building.store_product("Dwarf", 50000)
	assert_equal(0.0, @building.volume_available)
	
	assert_equal(hash_with_50k_dwarves, @building.stored_products)
	
	# Even one more dwarf would overflow it. Make sure it errors.
	assert_raise do
	  @building.store_product("Dwarf", 1)
	end
	
	# Make sure command center doesn't change.
	assert_equal(hash_with_50k_dwarves, @building.stored_products)
	
	# An Ancient Beast (P1), being larger than a dwarf (P0) obviously should overflow too.
	assert_raise do
	  @building.store_product("Ancient Beast", 1)
	end
	
	# Make sure command center doesn't change.
	assert_equal(hash_with_50k_dwarves, @building.stored_products)
  end
  
  def test_command_center_errors_if_removing_a_product_that_doesnt_exist
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
  
  def test_command_center_removes_product_completely_if_more_than_value_is_removed
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
  
  def test_command_center_can_show_total_volume
	# Default
	assert_equal(500.0, @building.total_volume)
	
	# After adding a product.
	@building.store_product("Dwarf", 1)
	assert_equal(500.0, @building.total_volume)
	
	# After adding second, different p-level product.
	@building.store_product("Ancient Beast", 1)
	assert_equal(500.0, @building.total_volume)
  end
  
  def test_command_center_can_show_volume_available
	# Default
	assert_equal(500.0, @building.volume_available)
	
	# After adding a product.
	# P-level 0 products should take up 0.01 per unit.
	@building.store_product("Dwarf", 1)
	assert_equal(499.99, @building.volume_available)
	
	# After adding second, different p-level product.
	# P-level 1 products should take up 0.38 per unit.
	@building.store_product("Ancient Beast", 1)
	assert_equal(499.61, @building.volume_available)
  end
  
  def test_command_center_can_show_volume_used
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
  
  
  
  # 
  # "Observable" tests
  # 
  
  def test_command_center_is_observable
	assert_true(@building.is_a?(Observable), "CC did not include Observable.")
  end
  
  # Update method for testing observer.
  def update
	@was_notified_of_change = true
  end
  
  def test_command_center_notifies_observers_on_level_increase
	@building.add_observer(self)
	
	@building.increase_level
	assert_true(@was_notified_of_change, "CC did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_command_center_does_not_notify_observers_if_level_increase_fails
	@building.set_level(5)
	
	# Start watching @building.
	@building.add_observer(self)
	
	@building.increase_level
	assert_false(@was_notified_of_change, "CC called notify_observers when its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_command_center_notifies_observers_on_level_decrease
	# Have to be at an above-zero level to decrease properly.
	@building.set_level(3)
	
	# Start watching @building.
	@building.add_observer(self)
	
	@building.decrease_level
	assert_true(@was_notified_of_change, "CC did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_command_center_does_not_notify_observers_if_level_decrease_fails
	@building.add_observer(self)
	
	@building.decrease_level
	assert_false(@was_notified_of_change, "CC called notify_observers when its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_command_center_notifies_observers_on_level_set
	@building.add_observer(self)
	
	@building.set_level(3)
	assert_true(@was_notified_of_change, "CC did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_command_center_does_not_notify_observers_if_level_set_fails
	@building.set_level(3)
	
	@building.add_observer(self)
	
	@building.set_level(3)
	assert_false(@was_notified_of_change, "CC called notify_observers when its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_default_num_observers_is_zero
	assert_equal(0, @building.count_observers)
  end
  
  # Storage / Observer tests.
  
  def test_command_center_notifies_observers_on_store_product
	pend
  end
  
  def test_command_center_does_not_notify_observers_if_store_product_fails
	pend
  end
  
  def test_command_center_notifies_observers_on_store_product_instance
	pend
  end
  
  def test_command_center_does_not_notify_observers_if_store_product_instance_fails
	pend
  end
  
  def test_command_center_notifies_observers_on_product_remove_all
	pend
  end
  
  def test_command_center_does_not_notify_observers_if_product_remove_all_fails
	pend
  end
  
  def test_command_center_notifies_observers_on_product_remove_quantity
	pend
  end
  
  def test_command_center_does_not_notify_observers_if_product_remove_quantity_fails
	pend
  end
end