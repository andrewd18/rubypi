require "test/unit"

require_relative "../model/basic_industrial_facility.rb"
require_relative "../model/schematic.rb"

class TestCaseBasicIndustrialFacility < Test::Unit::TestCase
  # Run once.
  def self.startup
	# Create some products and schematics for them.
	@@stick = Product.new("Stick", 0)
	@@stone = Product.new("Stone", 0)
	@@plank = Product.new("Plank", 0)
	@@beatstick = Product.new("Beatstick", 1)
	@@bonebreaker = Product.new("Bonebreaker", 1)
	@@bonebreaker_beatstick = Product.new("Bonebreaker Beatstick", 2)
	
	@@beatstick_schematic = Schematic.new("Beatstick", 1, {"Plank" => 10, "Stone" => 10})
	@@bonebreaker_schematic = Schematic.new("Bonebreaker", 1, {"Stick" => 100, "Stone" => 100})
	@@bonebreaker_beatstick_schematic = Schematic.new("Bonebreaker Beatstick", 1, {"Bonebreaker" => 1, "Beatstick" => 1})
  end
  
  # Run once after all tests.
  def self.shutdown
	Product.delete(@@stick)
	Product.delete(@@stone)
	Product.delete(@@plank)
	Product.delete(@@beatstick)
	Product.delete(@@bonebreaker)
	Product.delete(@@bonebreaker_beatstick)
	
	Schematic.delete(@@beatstick_schematic)
	Schematic.delete(@@bonebreaker_schematic)
	Schematic.delete(@@bonebreaker_beatstick_schematic)
  end
  
  # Run before every test.
  def setup
	@building = BasicIndustrialFacility.new
	@was_notified_of_change = false
  end
  
  # Run after every test.
  def teardown
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
	@building.schematic_name = "Bonebreaker"
	assert_equal("Bonebreaker", @building.schematic_name)
	assert_equal(@@bonebreaker_schematic, @building.schematic)
  end
  
  def test_facility_errors_if_schematic_is_not_acceptable
	assert_equal(nil, @building.schematic_name)
	
	# Should fail if name is not a String.
	assert_raise ArgumentError do
	  @building.schematic_name = (1236423254)
	end
	
	# Should fail is name is not a valid Schematic.
	assert_raise ArgumentError do
	  @building.schematic_name = ("faaaaaaail")
	end
	
	# Should fail if the p_level doesn't match.
	# AKA Basic facilities can only build P1s, Advanced can build 2 and 3, etc.
	assert_raise ArgumentError do
	  @building.schematic_name = ("Bonebreaker Beatstick")
	end
	
	# Make sure it wasn't set.
	assert_equal(nil, @building.schematic_name)
  end
  
  def test_set_schematic_shows_right_produces_product_name
	@building.schematic_name = "Bonebreaker"
	
	assert_equal("Bonebreaker", @building.produces_product_name)
  end
  
  def test_accepted_schematic_names
	# We should only accept schematics which have a p-level of 1.
	assert_equal(["Beatstick", "Bonebreaker"], @building.accepted_schematic_names)
  end
  
  def test_remove_schematic
	@building.schematic_name = "Bonebreaker"
	assert_equal("Bonebreaker", @building.schematic_name)
	assert_equal(@@bonebreaker_schematic, @building.schematic)
	
	@building.schematic_name = nil
	assert_equal(nil, @building.schematic_name)
	assert_equal(nil, @building.schematic)
  end
  
  def test_schematic_refers_to_schematic_singleton
	@building.schematic_name = "Beatstick"
	assert_equal(@building.schematic.object_id, @@beatstick_schematic.object_id)
  end
  
  def test_facility_stores_default_cycle_time_in_minutes
	assert_equal(30, @building.cycle_time)
  end
  
  def test_facility_can_give_us_a_cycle_time_in_minutes
	assert_equal(30, @building.cycle_time_in_minutes)
  end
  
  def test_facility_can_give_us_a_cycle_time_in_hours
	assert_equal(0.5, @building.cycle_time_in_hours)
  end
  
  def test_facility_can_give_us_a_cycle_time_in_days
	assert_equal(0.020833333333333332, @building.cycle_time_in_days)
  end
  
  def test_facility_does_not_let_user_change_cycle_time
	assert_false(@building.respond_to?(:cycle_time=))
  end
  
  #
  # Industrial Facility Storage behavior tests.
  #
  
  def test_facility_included_industrial_facility_storage_module
	assert_true(@building.is_a?(IndustrialFacilityStorage))
  end
  
  # Make sure we call industrial_facility_storage_schematic_changed
  def test_set_schematic_name_from_nil_to_a_valid_schematic
	empty_storage_hash = {}
	bonebreaker_storage_hash = {"Stick" => 0, "Stone" => 0}
	
	assert_equal(empty_storage_hash, @building.stored_products)
	
	@building.schematic_name = "Bonebreaker"
	
	# Make sure we call industrial_facility_storage_schematic_changed
	assert_equal(bonebreaker_storage_hash, @building.stored_products)
  end
  
  # Make sure we call industrial_facility_storage_schematic_changed
  def test_set_schematic_name_from_one_schematic_to_another
	empty_storage_hash = {}
	bonebreaker_storage_hash = {"Stick" => 0, "Stone" => 0}
	beatstick_storage_hash = {"Plank" => 0, "Stone" => 0}
	
	assert_equal(empty_storage_hash, @building.stored_products)
	
	@building.schematic_name = "Bonebreaker"
	
	# Make sure we call industrial_facility_storage_schematic_changed
	assert_equal(bonebreaker_storage_hash, @building.stored_products)
	
	@building.schematic_name = "Beatstick"
	
	# Make sure we call industrial_facility_storage_schematic_changed
	assert_equal(beatstick_storage_hash, @building.stored_products)
  end
  
  # Make sure we call industrial_facility_storage_schematic_changed
  def test_set_schematic_name_from_one_schematic_to_nil
	empty_storage_hash = {}
	bonebreaker_storage_hash = {"Stick" => 0, "Stone" => 0}
	
	@building.schematic_name = "Bonebreaker"
	
	# Make sure we call industrial_facility_storage_schematic_changed
	assert_equal(bonebreaker_storage_hash, @building.stored_products)
	
	@building.schematic_name = nil
	
	# Make sure we call industrial_facility_storage_schematic_changed
	assert_equal(empty_storage_hash, @building.stored_products)
  end
  
  # 
  # "Observable" tests
  # 
  
  def test_facility_is_observable
	assert_true(@building.is_a?(Observable), "Basic Industrial Facility did not include Observable.")
  end
  
  # Update method for testing observer.
  def update
	@was_notified_of_change = true
  end
  
  def test_facility_notifies_observers_on_schematic_set
	@building.add_observer(self)
	
	@building.schematic_name = "Bonebreaker"
	
	assert_true(@was_notified_of_change, "Basic Industrial Facility did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_facility_notifies_observers_on_schematic_set_to_nil
	@building.schematic_name = "Bonebreaker"
	
	@building.add_observer(self)
	
	@building.schematic_name = nil
	
	assert_true(@was_notified_of_change, "Basic Industrial Facility did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_facility_does_not_notify_observers_on_schematic_set_failure
	# Should fail if name is not a String.
	assert_raise ArgumentError do
	  @building.schematic_name = (1236423254)
	end
	assert_false(@was_notified_of_change, "Basic Industrial Facility called notify_observers when its state did not change.")
	
	# Should fail is name is not a valid Schematic.
	assert_raise ArgumentError do
	  @building.schematic_name = ("faaaaaaail")
	end
	assert_false(@was_notified_of_change, "Basic Industrial Facility called notify_observers when its state did not change.")
	
	# Make sure it wasn't set.
	assert_equal(nil, @building.schematic_name)
  end
  
  def test_facility_does_not_notify_observers_if_schematic_doesnt_change
	@building.schematic_name = "Bonebreaker"
	
	@building.add_observer(self)
	
	@building.schematic_name = "Bonebreaker"
	
	assert_false(@was_notified_of_change, "Basic Industrial Facility called notify_observers when its state did not change.")
	
	@building.delete_observer(self)
  end
end