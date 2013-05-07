require "test/unit"
require "observer"
require_relative "../model/industrial_facility_storage.rb"

class IndustrialFacilityStorageStub
  include Observable
  include IndustrialFacilityStorage
  
  # TODO
  # Add required methods here.
end

class TestCaseIndustrialFacilityStorage < Test::Unit::TestCase
  # Run once.
  def self.startup
	@@chiral_structures = Product.find_or_create("Chiral Structures", 0)
	@@silicon = Product.find_or_create("Silicon", 0)
	@@miniature_electronics = Product.find_or_create("Miniature Electronics", 1)
  end
  
  # Run once after all tests.
  def self.shutdown
	Product.delete(@@chiral_structures)
	Product.delete(@@silicon)
	Product.delete(@@miniature_electronics)
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
	pend
	# method: industrial_facility_storage_schematic_changed
	
	# New, empty storages should be created.
	# The number of storages created should be equal to the number of inputs on the schematic.
	# Storages should only hold schematic.inputquantity amount of items.
  end
  
  def test_industrial_facility_storage_schematic_changed_when_schematic_changes_from_one_valid_schematic_to_another
	pend
	# method: industrial_facility_storage_schematic_changed
	
	# All stored products should be deleted.
	# All existing storages should be deleted.
	# New, empty storages should be created.
	# The number of storages created should be equal to the number of inputs on the schematic.
	# Storages should only hold schematic.inputquantity amount of items.
  end
  
  def test_industrial_facility_storage_schematic_changed_when_schematic_changes_from_a_valid_schematic_to_nil
	pend
	# method: industrial_facility_storage_schematic_changed
	
	# All stored products should be deleted.
	# No new storages should be created.
  end
  
  def test_store_product_should_error_when_schematic_name_is_nil
	pend
	# No change should occur in the stored products.
  end
  
  def test_store_product_should_store_product_in_appropriate_storage
	pend
	# Start with empty but valid storages.
	# Add a product.
	# Make sure the right bucket got the product and quantity.
	# Make sure the wrong buckets are still empty.
  end
  
  def test_store_product_should_error_when_given_product_is_not_an_input_on_the_schematic
	pend
	# Start with empty but valid storages.
	# Add a product that is completely unrelated.
	# Make sure we error.
	# Make sure the buckets are still empty.
  end
  
  def test_store_product_should_error_when_given_product_amount_would_overflow_storage
	pend
	# Start with empty but valid storages.
	# Add wayyyy too much of a valid product.
	# Make sure we error.
	# Make sure the buckets are still empty.
  end
  
  def test_remove_all_of_product_should_error_when_schematic_name_is_nil
	pend
	# No change should occur in the stored products.
  end
  
  def test_remove_all_of_product_should_remove_product_from_appropriate_storage
	pend
	# Start with empty but valid storages.
	# Fill each storage to brim.
	# Remove all of one.
	# Make sure the right bucket is empty.
	# Make sure the wrong buckets are still full.
  end
  
  def test_remove_all_of_product_should_error_when_given_product_is_not_an_input_on_the_schematic
	pend
	# Start with empty but valid storages.
	# Fill each storage to brim.
	# Remove all of something completely unrelated.
	# Make sure we error.
	# Make sure the buckets are still full.
  end
  
  def test_remove_qty_of_product_should_error_when_schematic_name_is_nil
	pend
	# No change should occur in the stored products.
  end
  
  def test_remove_qty_of_product_should_remove_product_from_appropriate_storage
	pend
	# Start with empty but valid storages.
	# Fill each storage to brim.
	# Remove half of one.
	# Make sure the right bucket is at half.
	# Make sure the wrong buckets are still full.
  end
  
  def test_remove_qty_of_product_should_error_when_given_product_is_not_an_input_on_the_schematic
	pend
	# Start with empty but valid storages.
	# Fill each storage to brim.
	# Remove quantity of something completely unrelated.
	# Make sure we error.
	# Make sure the buckets are still full.
  end
  
  def test_remove_qty_of_product_should_remove_all_of_product_from_appropriate_storage_if_remove_qty_is_more_than_stored_qty
	pend
	# Start with empty but valid storages.
	# Fill each storage to brim.
	# Remove double of one.
	# Make sure the right bucket is empty and not a negative value.
	# Make sure the other buckets are still full.
  end
end