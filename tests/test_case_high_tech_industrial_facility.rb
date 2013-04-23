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
	
	# Level 3 Schematics
	@@kuat_schematic = Schematic.new("Kuat", 1, {"Drive Yards" => 1, "Planet" => 1})
	
	# Level 4 Schematics
	@@galactic_core_schematic = Schematic.new("Galactic Core", 1, {"Coruscant" => 1, "Alderaan" => 1, "Kuat" => 1})
  end
  
  # Run once after all tests.
  def self.shutdown
	Product.delete(@@coruscant)
	Product.delete(@@alderaan)
	Product.delete(@@kuat)
	Product.delete(@@galactic_core)
	
	Schematic.delete(@@galactic_core_schematic)
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
  
  def test_accepted_schematic_names
	# We should only accept schematics which have a p-level of 4.
	assert_equal(["Galactic Core"], @building.accepted_schematic_names)
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