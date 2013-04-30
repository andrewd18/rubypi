require "test/unit"

require_relative "../view/building_image.rb"
require_relative "../model/command_center.rb"
require_relative "../model/basic_industrial_facility.rb"
require_relative "../model/advanced_industrial_facility.rb"
require_relative "../model/high_tech_industrial_facility.rb"
require_relative "../model/extractor.rb"
require_relative "../model/extractor_head.rb"
require_relative "../model/storage_facility.rb"
require_relative "../model/launchpad.rb"


class TestCaseBuildingImage < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@command_center = CommandCenter.new
	@basic_industrial_facility = BasicIndustrialFacility.new
	@advanced_industrial_facility = AdvancedIndustrialFacility.new
	@high_tech_industrial_facility = HighTechIndustrialFacility.new
	@extractor = Extractor.new
	@extractor_head = ExtractorHead.new
	@storage_facility = StorageFacility.new
	@launchpad = Launchpad.new
	
	@building_image = BuildingImage.new(@command_center)
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_can_be_asked_about_its_model_object
	assert_equal(@command_center, @building_image.building_model)
  end
  
  def test_does_not_observe_model_object_by_default
	assert_equal(0, @building_image.building_model.count_observers)
  end
  
  def test_can_be_told_to_start_observing_model_object
	assert_equal(0, @building_image.building_model.count_observers)
	
	@building_image.start_observing_model
	
	# One observer for self.
	assert_equal(1, @building_image.building_model.count_observers)
  end
  
  def test_can_be_told_to_stop_observing_model_object
	assert_equal(0, @building_image.building_model.count_observers)
	
	@building_image.start_observing_model
	
	# One observer for self.
	assert_equal(1, @building_image.building_model.count_observers)
	
	@building_image.stop_observing_model
	
	assert_equal(0, @building_image.building_model.count_observers)
  end
  
  def test_can_be_assigned_new_model_object
	# Assign a BasicIndustrialFacility
	@building_image.building_model = @basic_industrial_facility
	
	assert_false(@building_image.building_model == @command_center)
	assert_false(@building_image.building_model == @advanced_industrial_facility)
	assert_false(@building_image.building_model == @high_tech_industrial_facility)
	assert_false(@building_image.building_model == @extractor)
	assert_false(@building_image.building_model == @extractor_head)
	assert_false(@building_image.building_model == @storage_facility)
	assert_false(@building_image.building_model == @launchpad)
	assert_equal(@basic_industrial_facility, @building_image.building_model)
	
	# Assign a AdvancedIndustrialFacility
	@building_image.building_model = @advanced_industrial_facility
	
	assert_false(@building_image.building_model == @command_center)
	assert_false(@building_image.building_model == @basic_industrial_facility)
	assert_false(@building_image.building_model == @high_tech_industrial_facility)
	assert_false(@building_image.building_model == @extractor)
	assert_false(@building_image.building_model == @extractor_head)
	assert_false(@building_image.building_model == @storage_facility)
	assert_false(@building_image.building_model == @launchpad)
	assert_equal(@advanced_industrial_facility, @building_image.building_model)
	
	# Assign a HighTechIndustrialFacility
	@building_image.building_model = @high_tech_industrial_facility
	
	assert_false(@building_image.building_model == @command_center)
	assert_false(@building_image.building_model == @basic_industrial_facility)
	assert_false(@building_image.building_model == @advanced_industrial_facility)
	assert_false(@building_image.building_model == @extractor)
	assert_false(@building_image.building_model == @extractor_head)
	assert_false(@building_image.building_model == @storage_facility)
	assert_false(@building_image.building_model == @launchpad)
	assert_equal(@high_tech_industrial_facility, @building_image.building_model)
	
	# Assign an Extractor
	@building_image.building_model = @extractor
	
	assert_false(@building_image.building_model == @command_center)
	assert_false(@building_image.building_model == @basic_industrial_facility)
	assert_false(@building_image.building_model == @advanced_industrial_facility)
	assert_false(@building_image.building_model == @high_tech_industrial_facility)
	assert_false(@building_image.building_model == @extractor_head)
	assert_false(@building_image.building_model == @storage_facility)
	assert_false(@building_image.building_model == @launchpad)
	assert_equal(@extractor, @building_image.building_model)
	
	# Assign an Extractor
	@building_image.building_model = @extractor_head
	
	assert_false(@building_image.building_model == @command_center)
	assert_false(@building_image.building_model == @basic_industrial_facility)
	assert_false(@building_image.building_model == @advanced_industrial_facility)
	assert_false(@building_image.building_model == @high_tech_industrial_facility)
	assert_false(@building_image.building_model == @extractor)
	assert_false(@building_image.building_model == @storage_facility)
	assert_false(@building_image.building_model == @launchpad)
	assert_equal(@extractor_head, @building_image.building_model)
	
	# Assign a StorageFacility
	@building_image.building_model = @storage_facility
	
	assert_false(@building_image.building_model == @command_center)
	assert_false(@building_image.building_model == @basic_industrial_facility)
	assert_false(@building_image.building_model == @advanced_industrial_facility)
	assert_false(@building_image.building_model == @high_tech_industrial_facility)
	assert_false(@building_image.building_model == @extractor)
	assert_false(@building_image.building_model == @extractor_head)
	assert_false(@building_image.building_model == @launchpad)
	assert_equal(@storage_facility, @building_image.building_model)
	
	# Assign a Launchpad
	@building_image.building_model = @launchpad
	
	assert_false(@building_image.building_model == @command_center)
	assert_false(@building_image.building_model == @basic_industrial_facility)
	assert_false(@building_image.building_model == @advanced_industrial_facility)
	assert_false(@building_image.building_model == @high_tech_industrial_facility)
	assert_false(@building_image.building_model == @extractor)
	assert_false(@building_image.building_model == @extractor_head)
	assert_false(@building_image.building_model == @storage_facility)
	assert_equal(@launchpad, @building_image.building_model)
  end
  
  def test_when_destroyed_unhooks_observers
	@building_image.start_observing_model
	
	# One observer for self.
	assert_equal(1, @command_center.count_observers)
	
	@building_image.destroy
	
	assert_equal(0, @command_center.count_observers)
  end
end