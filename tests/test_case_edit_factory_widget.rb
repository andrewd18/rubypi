require "test/unit"

require_relative "../view/edit_factory_widget.rb"
require_relative "../model/basic_industrial_facility.rb"
require_relative "../model/advanced_industrial_facility.rb"
require_relative "../model/high_tech_industrial_facility.rb"

class TestCaseEditFactoryWidget < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@basic_industrial_facility = BasicIndustrialFacility.new
	@advanced_industrial_facility = AdvancedIndustrialFacility.new
	@high_tech_industrial_facility = HighTechIndustrialFacility.new
	
	planet = Planet.new("Lava")
	@basic_industrial_facility.planet = planet
	@advanced_industrial_facility.planet = planet
	@high_tech_industrial_facility.planet = planet
	
	@edit_factory_widget = EditFactoryWidget.new(@basic_industrial_facility)
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_can_be_asked_about_its_model_object
	assert_equal(@basic_industrial_facility, @edit_factory_widget.building_model)
  end
  
  def test_does_not_observe_model_object_by_default
	assert_equal(0, @edit_factory_widget.building_model.count_observers)
  end
  
  def test_can_be_told_to_start_observing_model_object
	assert_equal(0, @edit_factory_widget.building_model.count_observers)
	
	@edit_factory_widget.start_observing_model
	
	# One observer for self.
	assert_equal(1, @edit_factory_widget.building_model.count_observers)
  end
  
  def test_can_be_told_to_stop_observing_model_object
	assert_equal(0, @edit_factory_widget.building_model.count_observers)
	
	@edit_factory_widget.start_observing_model
	
	# One observer for self.
	assert_equal(1, @edit_factory_widget.building_model.count_observers)
	
	@edit_factory_widget.stop_observing_model
	
	assert_equal(0, @edit_factory_widget.building_model.count_observers)
  end
  
  def test_can_be_assigned_new_model_object
	# Assign advanced.
	@edit_factory_widget.building_model = @advanced_industrial_facility
	
	assert_false(@edit_factory_widget.building_model == @basic_industrial_facility)
	assert_false(@edit_factory_widget.building_model == @high_tech_industrial_facility)
	assert_equal(@advanced_industrial_facility, @edit_factory_widget.building_model)
	
	# Assign high tech.
	@edit_factory_widget.building_model = @high_tech_industrial_facility
	
	assert_false(@edit_factory_widget.building_model == @basic_industrial_facility)
	assert_false(@edit_factory_widget.building_model == @advanced_industrial_facility)
	assert_equal(@high_tech_industrial_facility, @edit_factory_widget.building_model)
  end
  
  def test_when_destroyed_unhooks_observers
	@edit_factory_widget.start_observing_model
	
	# One observer for self.
	assert_equal(1, @basic_industrial_facility.count_observers)
	
	@edit_factory_widget.destroy
	
	assert_equal(0, @basic_industrial_facility.count_observers)
  end
end