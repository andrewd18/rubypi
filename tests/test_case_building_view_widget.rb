require "test/unit"

require_relative "../view/building_view_widget.rb"
# require_relative "../model/basic_industrial_facility.rb"

class TestCaseBuildingViewWidget < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	# TODO -test with multiple building types.
	@basic_industrial_facility = BasicIndustrialFacility.new
	@advanced_industrial_facility = AdvancedIndustrialFacility.new
	@high_tech_industrial_facility = HighTechIndustrialFacility.new
	@extractor = Extractor.new
	
	@building_view_widget = BuildingViewWidget.new(@basic_industrial_facility)
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_can_be_asked_about_its_model_object
	assert_equal(@basic_industrial_facility, @building_view_widget.building_model)
  end
  
  def test_does_not_observe_model_object_by_default
	assert_equal(0, @building_view_widget.building_model.count_observers)
  end
  
  def test_can_be_told_to_start_observing_model_object
	assert_equal(0, @building_view_widget.building_model.count_observers)
	
	@building_view_widget.start_observing_model
	
	if (@building_view_widget.building_widget.is_a?(Gtk::Label))
	  # One observer for self.
	  assert_equal(1, @building_view_widget.building_model.count_observers)
	else
	  # One observer for self, one for its @building_widget.
	  assert_equal(2, @building_view_widget.building_model.count_observers)
	end
  end
  
  def test_can_be_told_to_stop_observing_model_object
	assert_equal(0, @building_view_widget.building_model.count_observers)
	
	@building_view_widget.start_observing_model
	
	if (@building_view_widget.building_widget.is_a?(Gtk::Label))
	  # One observer for self.
	  assert_equal(1, @building_view_widget.building_model.count_observers)
	else
	  # One observer for self, one for its @building_widget.
	  assert_equal(2, @building_view_widget.building_model.count_observers)
	end
	
	@building_view_widget.stop_observing_model
	
	assert_equal(0, @building_view_widget.building_model.count_observers)
  end
  
  # TODO
  # This test probably needs to be complemented with a test that will switch out the building-specific sub-widget on the fly.
  def test_can_be_assigned_new_model_object
	# Assign advanced.
	@building_view_widget.building_model = @advanced_industrial_facility
	
	assert_false(@building_view_widget.building_model == @basic_industrial_facility)
	assert_false(@building_view_widget.building_model == @high_tech_industrial_facility)
	assert_false(@building_view_widget.building_model == @extractor)
	assert_equal(@advanced_industrial_facility, @building_view_widget.building_model)
	
	# Assign high tech.
	@building_view_widget.building_model = @high_tech_industrial_facility
	
	assert_false(@building_view_widget.building_model == @basic_industrial_facility)
	assert_false(@building_view_widget.building_model == @advanced_industrial_facility)
	assert_false(@building_view_widget.building_model == @extractor)
	assert_equal(@high_tech_industrial_facility, @building_view_widget.building_model)
	
	# Assign extractor.
	@building_view_widget.building_model = @extractor
	
	assert_false(@building_view_widget.building_model == @basic_industrial_facility)
	assert_false(@building_view_widget.building_model == @advanced_industrial_facility)
	assert_false(@building_view_widget.building_model == @high_tech_industrial_facility)
	assert_equal(@extractor, @building_view_widget.building_model)
  end
  
  def test_when_destroyed_unhooks_observers
	@building_view_widget.start_observing_model
	
	if (@building_view_widget.building_widget.is_a?(Gtk::Label))
	  # One observer for self.
	  assert_equal(1, @building_view_widget.building_model.count_observers)
	else
	  # One observer for self, one for its @building_widget.
	  assert_equal(2, @building_view_widget.building_model.count_observers)
	end
	
	@building_view_widget.destroy
	
	assert_equal(0, @basic_industrial_facility.count_observers)
  end
end