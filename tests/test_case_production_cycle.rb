require "test/unit"

require_relative '../model/production_cycle.rb'
require_relative '../model/storage_facility.rb'

class ProductionCycleStub
  include ProductionCycle
end

class TestCaseProductionCycle < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@pcstub = ProductionCycleStub.new
  end
  
  # Run after every test.
  def teardown
  end
  
  
  
  # Inputs
  def test_input_buildings_starts_off_empty
	assert_equal([], @pcstub.production_cycle_input_buildings)
  end
  
  def test_can_add_and_read_production_cycle_input_buildings
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	
	@pcstub.add_production_cycle_input_building(storage_facility_a)
	@pcstub.add_production_cycle_input_building(storage_facility_b)
	
	assert_equal([storage_facility_a, storage_facility_b], @pcstub.production_cycle_input_buildings)
  end
  
  def test_on_set_input_building_raise_error_when_adding_non_planetary_building
	not_a_planetary_building = ProductionCycleStub.new
	
	assert_raise ArgumentError do
	  @pcstub.add_production_cycle_input_building(not_a_planetary_building)
	end
	
	assert_raise ArgumentError do
	  @pcstub.add_production_cycle_input_building(nil)
	end
  end
  
  def test_can_remove_specific_production_cycle_input_building
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	
	@pcstub.add_production_cycle_input_building(storage_facility_a)
	@pcstub.add_production_cycle_input_building(storage_facility_b)
	
	assert_equal([storage_facility_a, storage_facility_b], @pcstub.production_cycle_input_buildings)
	
	@pcstub.remove_production_cycle_input_building(storage_facility_a)
	
	assert_equal([storage_facility_b], @pcstub.production_cycle_input_buildings)
  end
  
  def test_can_remove_all_production_cycle_input_buildings
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	
	@pcstub.add_production_cycle_input_building(storage_facility_a)
	@pcstub.add_production_cycle_input_building(storage_facility_b)
	
	assert_equal([storage_facility_a, storage_facility_b], @pcstub.production_cycle_input_buildings)
	
	@pcstub.remove_all_production_cycle_input_buildings
	
	assert_equal([], @pcstub.production_cycle_input_buildings)
  end
  
  
  
  # Outputs
  def test_can_set_production_cycle_output_building
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	
	@pcstub.production_cycle_output_building = storage_facility_a
	
	assert_equal(storage_facility_a, @pcstub.production_cycle_output_building)
	
	@pcstub.production_cycle_output_building = storage_facility_b
	
	assert_equal(storage_facility_b, @pcstub.production_cycle_output_building)
  end
  
  def test_on_set_output_building_raise_error_when_adding_non_planetary_building
	not_a_planetary_building = ProductionCycleStub.new
	
	assert_raise ArgumentError do
	  @pcstub.production_cycle_output_building=(not_a_planetary_building)
	end
  end
  
  def test_can_set_production_cycle_output_to_nil
	@pcstub.production_cycle_output_building=(nil)
	
	assert_equal(nil, @pcstub.production_cycle_output_building)
  end
  
  
  
  # Cycle Time
  def test_can_set_and_read_production_cycle_time_in_minutes
	cycles = [15, 30, 45, 60, 120, 400, 28]
	
	cycles.each do |amount|
	  @pcstub.production_cycle_time_in_minutes = (amount)
	  
	  assert_equal(amount, @pcstub.production_cycle_time_in_minutes)
	end
  end
  
  def test_can_set_and_read_production_cycle_time_in_hours
	cycles = [15, 30, 45, 60, 120, 400, 28]
	
	cycles.each do |amount|
	  @pcstub.production_cycle_time_in_hours = (amount)
	  
	  assert_equal(amount, @pcstub.production_cycle_time_in_hours)
	end
  end
  
  def test_can_set_and_read_production_cycle_time_in_days
	cycles = [15, 30, 45, 60, 120, 400, 28]
	
	cycles.each do |amount|
	  @pcstub.production_cycle_time_in_days = (amount)
	  
	  assert_equal(amount, @pcstub.production_cycle_time_in_days)
	end
  end
  
  def test_can_set_in_one_interval_and_read_in_another
	# Set in minutes, read in hours and days.
	@pcstub.production_cycle_time_in_minutes = 30
	
	assert_equal(0.5, @pcstub.production_cycle_time_in_hours)
	assert_equal(0.020833333333333332, @pcstub.production_cycle_time_in_days)
	
	# Set in hours, read in minutes and days.
	@pcstub.production_cycle_time_in_hours = 2
	
	assert_equal(120, @pcstub.production_cycle_time_in_minutes)
	assert_equal(0.083333333333333332, @pcstub.production_cycle_time_in_days)
	
	# Set in days, read in minutes and hours.
	@pcstub.production_cycle_time_in_days = 1
	
	assert_equal(1440, @pcstub.production_cycle_time_in_minutes)
	assert_equal(24, @pcstub.production_cycle_time_in_hours)
  end
end