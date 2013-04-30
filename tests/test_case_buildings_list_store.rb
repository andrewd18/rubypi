require "test/unit"

require_relative "../view/buildings_list_store.rb"
require_relative "../model/planet.rb"

class TestCaseBuildingsListStore < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@default_planet_model = Planet.new("Lava")
	
	@buildings_list_store = BuildingsListStore.new(@default_planet_model)
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_can_be_asked_about_its_model_object
	assert_equal(@default_planet_model, @buildings_list_store.planet_model)
  end
  
  def test_does_not_observe_model_object_by_default
	assert_equal(0, @buildings_list_store.planet_model.count_observers)
  end
  
  def test_can_be_told_to_start_observing_model_object
	assert_equal(0, @buildings_list_store.planet_model.count_observers)
	
	@buildings_list_store.start_observing_model
	
	# One observer for self.
	assert_equal(1, @buildings_list_store.planet_model.count_observers)
  end
  
  def test_can_be_told_to_stop_observing_model_object
	assert_equal(0, @buildings_list_store.planet_model.count_observers)
	
	@buildings_list_store.start_observing_model
	
	# One observer for self.
	assert_equal(1, @buildings_list_store.planet_model.count_observers)
	
	@buildings_list_store.stop_observing_model
	
	assert_equal(0, @buildings_list_store.planet_model.count_observers)
  end
  
  def test_can_be_assigned_new_model_object
	new_planet = Planet.new("Temperate")
	
	@buildings_list_store.planet_model = new_planet
	
	assert_false(@buildings_list_store.planet_model == @default_planet_model)
	assert_equal(new_planet, @buildings_list_store.planet_model)
  end
  
  def test_when_destroyed_unhooks_observers
	@buildings_list_store.start_observing_model
	
	# One observer for self.
	assert_equal(1, @default_planet_model.count_observers)
	
	@buildings_list_store.destroy
	
	assert_equal(0, @default_planet_model.count_observers)
  end
end