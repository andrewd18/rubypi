require "test/unit"

require_relative "../view/system_view_planet_overview_widget.rb"
require_relative "../model/planet.rb"

class TestCaseSystemViewPlanetOverviewWidget < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@default_planet_model = Planet.new("Lava")
	
	@planet_overview_widget = SystemViewPlanetOverviewWidget.new(@default_planet_model)
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_can_be_asked_about_its_model_object
	assert_equal(@default_planet_model, @planet_overview_widget.planet_model)
  end
  
  def test_does_not_observe_model_object_by_default
	assert_equal(0, @planet_overview_widget.planet_model.count_observers)
  end
  
  def test_can_be_told_to_start_observing_model_object
	assert_equal(0, @planet_overview_widget.planet_model.count_observers)
	
	@planet_overview_widget.start_observing_model
	
	# One observer for self, one observer for child object PlanetImage, one for child object BuildingCountTable.
	assert_equal(3, @planet_overview_widget.planet_model.count_observers)
  end
  
  def test_can_be_told_to_stop_observing_model_object
	assert_equal(0, @planet_overview_widget.planet_model.count_observers)
	
	@planet_overview_widget.start_observing_model
	
	# One observer for self, one observer for child object PlanetImage, one for child object BuildingCountTable.
	assert_equal(3, @planet_overview_widget.planet_model.count_observers)
	
	@planet_overview_widget.stop_observing_model
	
	assert_equal(0, @planet_overview_widget.planet_model.count_observers)
  end
  
  def test_can_be_assigned_new_model_object
	new_planet = Planet.new("Temperate")
	
	@planet_overview_widget.planet_model = new_planet
	
	assert_false(@planet_overview_widget.planet_model == @default_planet_model)
	assert_equal(new_planet, @planet_overview_widget.planet_model)
  end
  
  def test_when_destroyed_unhooks_observers
	@planet_overview_widget.start_observing_model
	
	# One observer for self, one observer for child object PlanetImage, one for child object BuildingCountTable.
	assert_equal(3, @default_planet_model.count_observers)
	
	@planet_overview_widget.destroy
	
	assert_equal(0, @default_planet_model.count_observers)
  end
end