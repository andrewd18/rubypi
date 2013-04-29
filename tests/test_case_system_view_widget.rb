require "test/unit"

require_relative "../view/system_view_widget.rb"
require_relative "../model/pi_configuration.rb"

class TestCaseSystemViewWidget < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@default_pi_config_model = PIConfiguration.new
	@default_pi_config_model.add_planet(Planet.new("Lava"))
	
	@system_view_widget = SystemViewWidget.new(@default_pi_config_model)
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_can_be_asked_about_its_model_object
	assert_equal(@default_pi_config_model, @system_view_widget.pi_configuration_model)
  end
  
  def test_does_not_observe_model_object_by_default
	assert_equal(0, @system_view_widget.pi_configuration_model.count_observers)
  end
  
  def test_can_be_told_to_start_observing_model_object
	assert_equal(0, @system_view_widget.pi_configuration_model.count_observers)
	
	@system_view_widget.start_observing_model
	
	# One observer for self, one observer for child object SystemStatsWidget.
	assert_equal(2, @system_view_widget.pi_configuration_model.count_observers)
  end
  
  def test_can_be_told_to_stop_observing_model_object
	assert_equal(0, @system_view_widget.pi_configuration_model.count_observers)
	
	@system_view_widget.start_observing_model
	
	assert_equal(2, @system_view_widget.pi_configuration_model.count_observers)
	
	@system_view_widget.stop_observing_model
	
	assert_equal(0, @system_view_widget.pi_configuration_model.count_observers)
  end
  
  def test_can_be_assigned_new_model_object
	new_pi_configuration = PIConfiguration.new
	new_pi_configuration.add_planet(Planet.new("Temperate"))
	
	@system_view_widget.pi_configuration_model = new_pi_configuration
	
	assert_false(@system_view_widget.pi_configuration_model == @default_pi_config_model)
	assert_equal(new_pi_configuration, @system_view_widget.pi_configuration_model)
  end
  
  def test_when_destroyed_unhooks_observers
	@system_view_widget.start_observing_model
	
	assert_equal(2, @default_pi_config_model.count_observers)
	
	@system_view_widget.destroy
	
	assert_equal(0, @default_pi_config_model.count_observers)
  end
end