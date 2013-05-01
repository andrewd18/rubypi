require "test/unit"

require_relative "../view/planet_stats_widget.rb"
require_relative "../model/planet.rb"

class TestCasePlanetStatsWidget < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@default_planet_model = Planet.new("Lava")
	
	@planet_stats_widget = PlanetStatsWidget.new(@default_planet_model)
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_can_be_asked_about_its_model_object
	assert_equal(@default_planet_model, @planet_stats_widget.planet_model)
  end
  
  def test_does_not_observe_model_object_by_default
	assert_equal(0, @planet_stats_widget.planet_model.count_observers)
  end
  
  def test_can_be_told_to_start_observing_model_object
	assert_equal(0, @planet_stats_widget.planet_model.count_observers)
	
	@planet_stats_widget.start_observing_model
	
	# One observer for self, one for PlanetImage, one for BuildingCountTable.
	assert_equal(3, @planet_stats_widget.planet_model.count_observers)
  end
  
  def test_can_be_told_to_stop_observing_model_object
	assert_equal(0, @planet_stats_widget.planet_model.count_observers)
	
	@planet_stats_widget.start_observing_model
	
	# One observer for self, one for PlanetImage, one for BuildingCountTable.
	assert_equal(3, @planet_stats_widget.planet_model.count_observers)
	
	@planet_stats_widget.stop_observing_model
	
	assert_equal(0, @planet_stats_widget.planet_model.count_observers)
  end
  
  def test_can_be_assigned_new_model_object
	new_planet = Planet.new("Temperate")
	
	@planet_stats_widget.planet_model = new_planet
	
	assert_false(@planet_stats_widget.planet_model == @default_planet_model)
	assert_equal(new_planet, @planet_stats_widget.planet_model)
  end
  
  def test_when_destroyed_unhooks_observers
	@planet_stats_widget.start_observing_model
	
	# One observer for self, one for PlanetImage, one for BuildingCountTable.
	assert_equal(3, @default_planet_model.count_observers)
	
	@planet_stats_widget.destroy
	
	assert_equal(0, @default_planet_model.count_observers)
  end
  
  def test_can_access_planet_type_combo_box
	assert_true(@planet_stats_widget.planet_type_combo_box.is_a?(SimpleComboBox))
  end

  def test_commits_to_model_when_destroyed
	@planet_stats_widget.start_observing_model
	
	combo_box = @planet_stats_widget.planet_type_combo_box
	
	assert_equal("Lava", combo_box.selected_item)
	assert_equal("Lava", @default_planet_model.type)
	
	# Set the value to "Oceanic".
	combo_box.selected_item=("Oceanic")
	
	assert_equal("Oceanic", combo_box.selected_item)
	
	@planet_stats_widget.destroy
	
	assert_equal("Oceanic", @default_planet_model.type)
  end
end