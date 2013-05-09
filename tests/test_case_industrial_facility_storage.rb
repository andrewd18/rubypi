require "test/unit"
require "observer"
require_relative "../model/industrial_facility_storage.rb"

class IndustrialFacilityStorageStub
  include Observable
  include IndustrialFacilityStorage
  
  attr_reader :schematic
  
  def schematic=(new_schematic)
	@schematic = new_schematic
	
	self.industrial_facility_storage_schematic_changed
  end
end

class TestCaseIndustrialFacilityStorage < Test::Unit::TestCase
  # Run once.
  def self.startup
	@@chiral_structures = Product.find_or_create("Chiral Structures", 0)
	@@silicon = Product.find_or_create("Silicon", 0)
	@@miniature_electronics = Product.find_or_create("Miniature Electronics", 1)
	
	@@miniature_electronics_schematic = Schematic.new("Miniature Electronics", 5, {"Chiral Structures" => 40, "Silicon" => 40})
	
	@@mechanical_parts = Product.find_or_create("Mechanical Parts", 1)
	@@supertensile_plastics = Product.find_or_create("Supertensile Plastics", 1)
	# @@miniature_electronics already created
	
	@@planetary_vehicles = Product.find_or_create("Planetary Vehicles", 2)
	
	@@planetary_vehicles_schematic = Schematic.new("Planetary Vehicles", 3, {"Supertensile Plastics" => 10, "Mechanical Parts" => 10, "Miniature Electronics" => 10})
  end
  
  # Run once after all tests.
  def self.shutdown
	Product.delete(@@chiral_structures)
	Product.delete(@@silicon)
	Product.delete(@@miniature_electronics)
	
	Product.delete(@@mechanical_parts)
	Product.delete(@@supertensile_plastics)
	Product.delete(@@planetary_vehicles)
	
	Schematic.delete(@@miniature_electronics_schematic)
	Schematic.delete(@@planetary_vehicles_schematic)
  end

  # Run before every test.
  def setup
	@building_stub = IndustrialFacilityStorageStub.new
	@was_notified_of_change = false
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_industrial_facility_storage_schematic_changed_when_schematic_changes_from_nil_to_a_valid_schematic
	assert_equal(nil, @building_stub.schematic)
	@building_stub.schematic = @@miniature_electronics_schematic
	assert_equal(@@miniature_electronics_schematic, @building_stub.schematic)
	
	expected_storage_hash = {"Chiral Structures" => 0, "Silicon" => 0}
	
	assert_equal(expected_storage_hash, @building_stub.stored_products)
  end
  
  def test_industrial_facility_storage_schematic_changed_when_schematic_changes_from_one_valid_schematic_to_another
	# Repeat what we just did in the from_nil_to_valid test.
	@building_stub.schematic = @@miniature_electronics_schematic
	assert_equal(@@miniature_electronics_schematic, @building_stub.schematic)
	
	# Now set it to something else.
	@building_stub.schematic = @@planetary_vehicles_schematic
	assert_equal(@@planetary_vehicles_schematic, @building_stub.schematic)
	
	expected_storage_hash = {"Supertensile Plastics" => 0, "Mechanical Parts" => 0, "Miniature Electronics" => 0}
	
	assert_equal(expected_storage_hash, @building_stub.stored_products)
  end
  
  def test_industrial_facility_storage_schematic_changed_when_schematic_changes_from_a_valid_schematic_to_nil
	# Repeat what we just did in the from_nil_to_valid test.
	@building_stub.schematic = @@miniature_electronics_schematic
	assert_equal(@@miniature_electronics_schematic, @building_stub.schematic)
	
	# Now set it to nil.
	@building_stub.schematic = nil
	assert_equal(nil, @building_stub.schematic)
	
	empty_storage_hash = {}
	
	assert_equal(empty_storage_hash, @building_stub.stored_products)
  end
  
  def test_store_product_should_error_when_schematic_name_is_nil
	empty_storage_hash = {}
	
	assert_equal(nil, @building_stub.schematic)
	assert_equal(empty_storage_hash, @building_stub.stored_products)
	
	# Test adding 5 silicon.
	assert_raise ArgumentError do
	  @building_stub.store_product("Silicon", 5)
	end
	
	# Make sure nothing changed.
	assert_equal(nil, @building_stub.schematic)
	assert_equal(empty_storage_hash, @building_stub.stored_products)
  end
  
  def test_store_product_should_store_product_in_appropriate_storage
	# Repeat what we just did in the from_nil_to_valid test.
	@building_stub.schematic = @@miniature_electronics_schematic
	assert_equal(@@miniature_electronics_schematic, @building_stub.schematic)
	
	@building_stub.store_product("Silicon", 5)
	
	expected_storage_hash = {"Chiral Structures" => 0, "Silicon" => 5}
	
	assert_equal(expected_storage_hash, @building_stub.stored_products)
  end
  
  def test_store_product_should_error_when_given_product_is_not_an_input_on_the_schematic
	# Repeat what we just did in the from_nil_to_valid test.
	@building_stub.schematic = @@planetary_vehicles_schematic
	assert_equal(@@planetary_vehicles_schematic, @building_stub.schematic)
	
	assert_raise ArgumentError do
	  @building_stub.store_product("Silicon", 5)
	end
	
	expected_storage_hash = {"Supertensile Plastics" => 0, "Mechanical Parts" => 0, "Miniature Electronics" => 0}
	
	assert_equal(expected_storage_hash, @building_stub.stored_products)
  end
  
  def test_store_product_should_error_when_given_product_amount_would_overflow_storage
	# Repeat what we just did in the from_nil_to_valid test.
	@building_stub.schematic = @@miniature_electronics_schematic
	assert_equal(@@miniature_electronics_schematic, @building_stub.schematic)
	
	assert_raise ArgumentError do
	  @building_stub.store_product("Silicon", 9999)
	end
	
	empty_storage_hash = {"Chiral Structures" => 0, "Silicon" => 0}
	
	assert_equal(empty_storage_hash, @building_stub.stored_products)
	
	
	# Now attempt to overflow by one.
	# Set to max.
	@building_stub.store_product("Silicon", 40)
	
	assert_raise ArgumentError do
	  @building_stub.store_product("Silicon", 1)
	end
	
	expected_storage_hash = {"Chiral Structures" => 0, "Silicon" => 40}
	
	assert_equal(expected_storage_hash, @building_stub.stored_products)
  end
  
  def test_remove_all_of_product_should_error_when_schematic_name_is_nil
	empty_storage_hash = {}
	
	assert_equal(empty_storage_hash, @building_stub.stored_products)
	
	assert_raise ArgumentError do
	  @building_stub.remove_all_of_product("Mechanical Parts")
	end
	
	assert_equal(empty_storage_hash, @building_stub.stored_products)
  end
  
  def test_remove_all_of_product_should_remove_product_from_appropriate_storage
	@building_stub.schematic = @@miniature_electronics_schematic
	
	# Fill the storages up.
	@building_stub.store_product("Chiral Structures", 40)
	@building_stub.store_product("Silicon", 40)
	
	full_storage = {"Chiral Structures" => 40, "Silicon" => 40}
	storage_with_silicon_empty = {"Chiral Structures" => 40, "Silicon" => 0}
	
	assert_equal(full_storage, @building_stub.stored_products)
	
	@building_stub.remove_all_of_product("Silicon")
	
	assert_equal(storage_with_silicon_empty, @building_stub.stored_products)
  end
  
  def test_remove_all_of_product_should_error_when_given_product_is_not_an_input_on_the_schematic
	@building_stub.schematic = @@miniature_electronics_schematic
	
	# Fill the storages up.
	@building_stub.store_product("Chiral Structures", 40)
	@building_stub.store_product("Silicon", 40)
	
	full_storage = {"Chiral Structures" => 40, "Silicon" => 40}
	
	assert_equal(full_storage, @building_stub.stored_products)
	
	assert_raise ArgumentError do
	  @building_stub.remove_all_of_product("Mechanical Parts")
	end
	
	assert_equal(full_storage, @building_stub.stored_products)
  end
  
  def test_remove_qty_of_product_should_error_when_schematic_name_is_nil
	empty_storage_hash = {}
	
	assert_equal(nil, @building_stub.schematic)
	assert_equal(empty_storage_hash, @building_stub.stored_products)
	
	# Test removing 5 silicon.
	assert_raise ArgumentError do
	  @building_stub.remove_qty_of_product("Silicon", 5)
	end
	
	# Make sure nothing changed.
	assert_equal(nil, @building_stub.schematic)
	assert_equal(empty_storage_hash, @building_stub.stored_products)
  end
  
  def test_remove_qty_of_product_should_remove_product_from_appropriate_storage
	@building_stub.schematic = @@miniature_electronics_schematic
	
	# Fill the storages up.
	@building_stub.store_product("Chiral Structures", 40)
	@building_stub.store_product("Silicon", 40)
	
	full_storage = {"Chiral Structures" => 40, "Silicon" => 40}
	storage_with_silicon_half_empty = {"Chiral Structures" => 40, "Silicon" => 20}
	
	assert_equal(full_storage, @building_stub.stored_products)
	
	@building_stub.remove_qty_of_product("Silicon", 20)
	
	assert_equal(storage_with_silicon_half_empty, @building_stub.stored_products)
  end
  
  def test_remove_qty_of_product_should_error_when_given_product_is_not_an_input_on_the_schematic
	@building_stub.schematic = @@miniature_electronics_schematic
	
	# Fill the storages up.
	@building_stub.store_product("Chiral Structures", 40)
	@building_stub.store_product("Silicon", 40)
	
	full_storage = {"Chiral Structures" => 40, "Silicon" => 40}
	
	assert_equal(full_storage, @building_stub.stored_products)
	
	assert_raise ArgumentError do
	  @building_stub.remove_qty_of_product("Mechanical Parts", 20)
	end
	
	assert_equal(full_storage, @building_stub.stored_products)
  end
  
  def test_remove_qty_of_product_should_remove_all_of_product_from_appropriate_storage_if_remove_qty_is_more_than_stored_qty
	@building_stub.schematic = @@miniature_electronics_schematic
	
	# Fill the storages up.
	@building_stub.store_product("Chiral Structures", 40)
	@building_stub.store_product("Silicon", 40)
	
	full_storage = {"Chiral Structures" => 40, "Silicon" => 40}
	storage_with_silicon_empty = {"Chiral Structures" => 40, "Silicon" => 00}
	
	assert_equal(full_storage, @building_stub.stored_products)
	
	@building_stub.remove_qty_of_product("Silicon", 999999999)
	
	assert_equal(storage_with_silicon_empty, @building_stub.stored_products)
  end
end