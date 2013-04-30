require "test/unit"

require_relative "../view/edit_command_center_widget.rb"
require_relative "../model/command_center.rb"

class TestCaseEditCommandCenterWidget < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@default_building_model = CommandCenter.new
	
	@edit_command_center_widget = EditCommandCenterWidget.new(@default_building_model)
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_can_be_asked_about_its_model_object
	assert_equal(@default_building_model, @edit_command_center_widget.building_model)
  end
  
  def test_does_not_observe_model_object_by_default
	assert_equal(0, @edit_command_center_widget.building_model.count_observers)
  end
  
  def test_can_be_told_to_start_observing_model_object
	assert_equal(0, @edit_command_center_widget.building_model.count_observers)
	
	@edit_command_center_widget.start_observing_model
	
	# One observer for self.
	assert_equal(1, @edit_command_center_widget.building_model.count_observers)
  end
  
  def test_can_be_told_to_stop_observing_model_object
	assert_equal(0, @edit_command_center_widget.building_model.count_observers)
	
	@edit_command_center_widget.start_observing_model
	
	# One observer for self.
	assert_equal(1, @edit_command_center_widget.building_model.count_observers)
	
	@edit_command_center_widget.stop_observing_model
	
	assert_equal(0, @edit_command_center_widget.building_model.count_observers)
  end
  
  def test_can_be_assigned_new_model_object
	new_cc = CommandCenter.new
	
	@edit_command_center_widget.building_model = new_cc
	
	assert_false(@edit_command_center_widget.building_model == @default_building_model)
	assert_equal(new_cc, @edit_command_center_widget.building_model)
  end
  
  def test_when_destroyed_unhooks_observers
	@edit_command_center_widget.start_observing_model
	
	# One observer for self.
	assert_equal(1, @default_building_model.count_observers)
	
	@edit_command_center_widget.destroy
	
	assert_equal(0, @default_building_model.count_observers)
  end
end