require "test/unit"

require_relative '../model/production_cycle.rb'

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
  
  def test_can_read_production_cycle_inputs
	pend
  end
  
  def test_can_add_production_cycle_inputs
	pend
  end
  
  def test_can_remove_specific_production_cycle_input
	pend
  end
  
  def test_can_remove_all_production_cycle_inputs
	pend
  end
  
  # Outputs
  
  def test_can_read_production_cycle_output
	pend
  end
  
  def test_can_set_production_cycle_output
	pend
  end
  
  def test_can_clear_production_cycle_output
	pend
  end
  
  def test_can_set_production_cycle_output_to_nil
	# This should have the same effect as clear.
	pend
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