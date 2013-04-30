require "test/unit"

require_relative "../view/building_count_table.rb"
require_relative "../model/planet.rb"

class TestCaseBuildingCountTable < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@default_planet_model = Planet.new("Lava")
	
	@building_count_table = BuildingCountTable.new(@default_planet_model)
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_can_be_asked_about_its_model_object
	assert_equal(@default_planet_model, @building_count_table.planet_model)
  end
  
  def test_does_not_observe_model_object_by_default
	assert_equal(0, @building_count_table.planet_model.count_observers)
  end
  
  def test_can_be_told_to_start_observing_model_object
	assert_equal(0, @building_count_table.planet_model.count_observers)
	
	@building_count_table.start_observing_model
	
	# One observer for self.
	assert_equal(1, @building_count_table.planet_model.count_observers)
  end
  
  def test_can_be_told_to_stop_observing_model_object
	assert_equal(0, @building_count_table.planet_model.count_observers)
	
	@building_count_table.start_observing_model
	
	# One observer for self.
	assert_equal(1, @building_count_table.planet_model.count_observers)
	
	@building_count_table.stop_observing_model
	
	assert_equal(0, @building_count_table.planet_model.count_observers)
  end
  
  def test_can_be_assigned_new_model_object
	new_planet = Planet.new("Temperate")
	
	@building_count_table.planet_model = new_planet
	
	assert_false(@building_count_table.planet_model == @default_planet_model)
	assert_equal(new_planet, @building_count_table.planet_model)
  end
  
  def test_when_destroyed_unhooks_observers
	@building_count_table.start_observing_model
	
	# One observer for self.
	assert_equal(1, @default_planet_model.count_observers)
	
	@building_count_table.destroy
	
	assert_equal(0, @default_planet_model.count_observers)
  end
end