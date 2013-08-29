require "test/unit"

require_relative "../model/high_tech_industrial_facility.rb"
require_relative "../model/schematic.rb"

class TestCaseHighTechIndustrialFacility < Test::Unit::TestCase
  # Run once.
  def self.startup
	# Create some products and schematics for them.
	
	# Level 3 Products
	@@coruscant = Product.new("Coruscant", 3)
	@@alderaan = Product.new("Alderaan", 3)
	@@kuat = Product.new("Kuat", 3)
	
	# Level 4 Products
	@@galactic_core = Product.new("Galactic Core", 4)
	@@outer_rim = Product.new("Outer Rim", 4)
	
	# Level 3 Schematics
	@@kuat_schematic = Schematic.new("Kuat", 1, {"Drive Yards" => 1, "Planet" => 1})
	
	# Level 4 Schematics
	@@galactic_core_schematic = Schematic.new("Galactic Core", 1, {"Coruscant" => 1, "Alderaan" => 1, "Kuat" => 1})
	@@outer_rim_schematic = Schematic.new("Outer Rim", 1, {"Tattooine" => 1, "Dantooine" => 1})
  end
  
  # Run once after all tests.
  def self.shutdown
	Product.delete(@@coruscant)
	Product.delete(@@alderaan)
	Product.delete(@@kuat)
	Product.delete(@@galactic_core)
	Product.delete(@@outer_rim)
	
	Schematic.delete(@@galactic_core_schematic)
	Schematic.delete(@@outer_rim_schematic)
	Schematic.delete(@@kuat_schematic)
  end
  
  # Run before every test.
  def setup
	@building = HighTechIndustrialFacility.new
	@was_notified_of_change = false
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_powergrid_usage_value
	assert_equal(400, @building.powergrid_usage)
  end
  
  def test_cpu_usage_value
	assert_equal(1100, @building.cpu_usage)
  end
  
  def test_powergrid_provided_value
	assert_equal(0, @building.powergrid_provided)
  end
  
  def test_cpu_provided_value
	assert_equal(0, @building.cpu_provided)
  end
  
  def test_isk_cost_value
	assert_equal(525000.00, @building.isk_cost)
  end
  
  def test_name
	assert_equal("High Tech Industrial Facility", @building.name)
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
	@building = HighTechIndustrialFacility.new(1.5, 3.2, nil)
	assert_equal(1.5, @building.x_pos)
	assert_equal(3.2, @building.y_pos)
  end
  
  def test_set_schematic
	@building.schematic_name = "Galactic Core"
	assert_equal("Galactic Core", @building.schematic_name)
	assert_equal(@@galactic_core_schematic, @building.schematic)
  end
  
  def test_facility_errors_if_schematic_is_not_acceptable
	assert_equal(nil, @building.schematic_name)
	
	# Should fail if name is not a String.
	assert_raise ArgumentError do
	  @building.schematic_name = (1236423254)
	end
	
	# Should fail if name is not a valid Schematic.
	assert_raise ArgumentError do
	  @building.schematic_name = ("faaaaaaail")
	end
	
	# Should fail if the p_level doesn't match.
	# AKA Basic facilities can only build P1s, Advanced can build 2 and 3, etc.
	assert_raise ArgumentError do
	  @building.schematic_name = ("Kuat")
	end
	
	# Make sure it wasn't set.
	assert_equal(nil, @building.schematic_name)
  end
  
  def test_set_schematic_shows_right_produces_product_name
	@building.schematic_name = "Galactic Core"
	
	assert_equal("Galactic Core", @building.produces_product_name)
  end
  
  def test_accepted_schematic_names
	# We should only accept schematics which have a p-level of 4.
	assert_equal(["Galactic Core", "Outer Rim"], @building.accepted_schematic_names)
  end
  
  def test_remove_schematic
	@building.schematic_name = "Galactic Core"
	assert_equal("Galactic Core", @building.schematic_name)
	assert_equal(@@galactic_core_schematic, @building.schematic)
	
	@building.schematic_name = nil
	assert_equal(nil, @building.schematic_name)
	assert_equal(nil, @building.schematic)
  end
  
  def test_schematic_refers_to_schematic_singleton
	@building.schematic_name = "Galactic Core"
	assert_equal(@building.schematic.object_id, @@galactic_core_schematic.object_id)
  end
  
  def test_facility_without_schematic_has_empty_hash_inputs_per_cycle
	assert_equal(nil, @building.schematic_name)
	assert_equal({}, @building.input_products_per_cycle)
  end
  
  def test_facility_with_schematic_shows_accurate_inputs_per_cycle
	@building.schematic_name = "Galactic Core"
	hash_of_inputs_per_cycle = {"Coruscant" => 1, "Alderaan" => 1, "Kuat" => 1}
	
	assert_equal(hash_of_inputs_per_cycle, @building.input_products_per_cycle)
  end
  
  def test_facility_without_schematic_has_empty_hash_inputs_per_hour
	assert_equal(nil, @building.schematic_name)
	assert_equal({}, @building.input_products_per_hour)
  end
  
  def test_facility_with_schematic_shows_accurate_inputs_per_hour
	@building.schematic_name = "Galactic Core"
	hash_of_inputs_per_hour = {"Coruscant" => 1, "Alderaan" => 1, "Kuat" => 1}
	
	# Expected cycle time for a P4 is 1 per hour.
	assert_equal(hash_of_inputs_per_hour, @building.input_products_per_hour)
  end
  
  def test_facility_without_schematic_has_empty_hash_outputs_per_cycle
	assert_equal(nil, @building.schematic_name)
	assert_equal({}, @building.output_products_per_cycle)
  end
  
  def test_facility_with_schematic_shows_accurate_outputs_per_cycle
	@building.schematic_name = "Galactic Core"
	hash_of_outputs_per_cycle = {"Galactic Core" => 1}
	
	assert_equal(hash_of_outputs_per_cycle, @building.output_products_per_cycle)
  end
  
  def test_facility_without_schematic_has_empty_hash_outputs_per_hour
	assert_equal(nil, @building.schematic_name)
	assert_equal({}, @building.output_products_per_hour)
  end
  
  def test_facility_with_schematic_shows_accurate_outputs_per_hour
	@building.schematic_name = "Galactic Core"
	hash_of_outputs_per_hour = {"Galactic Core" => 1}
	
	assert_equal(hash_of_outputs_per_hour, @building.output_products_per_hour)
  end
  
  #
  # Cycle Time Module Interaction Tests
  #
  
  def test_facility_production_cycle_time_is_sixty_minutes
	assert_equal(60, @building.production_cycle_time_in_minutes)
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
	galactic_core_storage_hash = {"Coruscant" => 0, "Alderaan" => 0, "Kuat" => 0}
	
	assert_equal(empty_storage_hash, @building.stored_products)
	
	@building.schematic_name = "Galactic Core"
	
	# Make sure we call industrial_facility_storage_schematic_changed
	assert_equal(galactic_core_storage_hash, @building.stored_products)
  end
  
  # Make sure we call industrial_facility_storage_schematic_changed
  def test_set_schematic_name_from_one_schematic_to_another
	empty_storage_hash = {}
	galactic_core_storage_hash = {"Coruscant" => 0, "Alderaan" => 0, "Kuat" => 0}
	outer_rim_storage_hash = {"Tattooine" => 0, "Dantooine" => 0}
	
	assert_equal(empty_storage_hash, @building.stored_products)
	
	@building.schematic_name = "Galactic Core"
	
	# Make sure we call industrial_facility_storage_schematic_changed
	assert_equal(galactic_core_storage_hash, @building.stored_products)
	
	@building.schematic_name = "Outer Rim"
	
	# Make sure we call industrial_facility_storage_schematic_changed
	assert_equal(outer_rim_storage_hash, @building.stored_products)
  end
  
  # Make sure we call industrial_facility_storage_schematic_changed
  def test_set_schematic_name_from_one_schematic_to_nil
	empty_storage_hash = {}
	galactic_core_storage_hash = {"Coruscant" => 0, "Alderaan" => 0, "Kuat" => 0}
	
	@building.schematic_name = "Galactic Core"
	
	# Make sure we call industrial_facility_storage_schematic_changed
	assert_equal(galactic_core_storage_hash, @building.stored_products)
	
	@building.schematic_name = nil
	
	# Make sure we call industrial_facility_storage_schematic_changed
	assert_equal(empty_storage_hash, @building.stored_products)
  end
  
  # 
  # "Observable" tests
  # 
  
  def test_facility_is_observable
	assert_true(@building.is_a?(Observable), "High Tech Industrial Facility did not include Observable.")
  end
  
  # Update method for testing observer.
  def update
	@was_notified_of_change = true
  end
  
  def test_facility_notifies_observers_on_schematic_set
	@building.add_observer(self)
	
	@building.schematic_name = "Galactic Core"
	
	assert_true(@was_notified_of_change, "High Tech Industrial Facility did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_facility_notifies_observers_on_schematic_set_to_nil
	@building.schematic_name = "Galactic Core"
	
	@building.add_observer(self)
	
	@building.schematic_name = nil
	
	assert_true(@was_notified_of_change, "High Tech Industrial Facility did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_facility_does_not_notify_observers_on_schematic_set_failure
	# Should fail if name is not a String.
	assert_raise ArgumentError do
	  @building.schematic_name = (1236423254)
	end
	assert_false(@was_notified_of_change, "High Tech Industrial Facility called notify_observers when its state did not change.")
	
	# Should fail is name is not a valid Schematic.
	assert_raise ArgumentError do
	  @building.schematic_name = ("faaaaaaail")
	end
	assert_false(@was_notified_of_change, "High Tech Industrial Facility called notify_observers when its state did not change.")
	
	# Should fail if the p_level doesn't match.
	# AKA Basic facilities can only build P1s, Advanced can build 2 and 3, etc.
	assert_raise ArgumentError do
	  @building.schematic_name = ("Kuat")
	end
	assert_false(@was_notified_of_change, "High Tech Industrial Facility called notify_observers when its state did not change.")
	
	# Make sure it wasn't set.
	assert_equal(nil, @building.schematic_name)
  end
  
  def test_facility_does_not_notify_observers_if_schematic_doesnt_change
	@building.schematic_name = "Galactic Core"
	
	@building.add_observer(self)
	
	@building.schematic_name = "Galactic Core"
	
	assert_false(@was_notified_of_change, "High Tech Industrial Facility called notify_observers when its state did not change.")
	
	@building.delete_observer(self)
  end
end