require "test/unit"

require_relative "../model/extractor.rb"

class TestCaseExtractor < Test::Unit::TestCase
  # Run once.
  def self.startup
	@@carebear_tears = Product.new("Carebear Tears", 0)
	@@pirate_tears = Product.new("Pirate Tears", 1)
  end
  
  # Run once after all tests.
  def self.shutdown
	Product.delete(@@carebear_tears)
	Product.delete(@@pirate_tears)
  end
  
  # Run before every test.
  def setup
	@building = Extractor.new
	@was_notified_of_change = false
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_powergrid_usage_value
	assert_equal(2600, @building.powergrid_usage)
  end
  
  def test_cpu_usage_value
	assert_equal(400, @building.cpu_usage)
  end
  
  def test_powergrid_provided_value
	assert_equal(0, @building.powergrid_provided)
  end
  
  def test_cpu_provided_value
	assert_equal(0, @building.cpu_provided)
  end
  
  def test_isk_cost_value
	assert_equal(45000.00, @building.isk_cost)
  end
  
  def test_name
	assert_equal("Extractor", @building.name)
  end
  
  def test_extractor_starts_with_zero_heads
	assert_equal(0, @building.number_of_heads)
  end
  
  def test_extractor_can_add_and_then_returns_a_head
  	extractor_head_instance = @building.add_extractor_head
	assert_true(extractor_head_instance.is_a?(ExtractorHead))
  end
  
  def test_extractor_can_add_head_and_make_it_available_via_attr_reader
	head_one = @building.add_extractor_head
	head_two = @building.add_extractor_head
	head_three = @building.add_extractor_head
	head_four = @building.add_extractor_head
	
	assert_equal(4, @building.number_of_heads)
	
	assert_true(@building.extractor_heads.include?(head_one))
	assert_true(@building.extractor_heads.include?(head_two))
	assert_true(@building.extractor_heads.include?(head_three))
	assert_true(@building.extractor_heads.include?(head_four))
  end
  
  def test_extractor_cannot_add_more_than_ten_heads
	10.times do
	  @building.add_extractor_head
	end
	
	assert_equal(10, @building.number_of_heads)
	
	assert_raise RuntimeError do
	  @building.add_extractor_head
	end
	
	assert_equal(10, @building.number_of_heads)
  end
  
  def test_extractor_can_remove_specific_heads
	head_one = @building.add_extractor_head
	head_two = @building.add_extractor_head
	head_three = @building.add_extractor_head
	head_four = @building.add_extractor_head
	
	@building.remove_extractor_head(head_three)
	
	assert_equal(3, @building.number_of_heads)
	
	assert_true(@building.extractor_heads.include?(head_one))
	assert_true(@building.extractor_heads.include?(head_two))
	assert_false(@building.extractor_heads.include?(head_three))
	assert_true(@building.extractor_heads.include?(head_four))
  end
  
  def test_extractor_can_remove_all_heads
	head_one = @building.add_extractor_head
	head_two = @building.add_extractor_head
	head_three = @building.add_extractor_head
	head_four = @building.add_extractor_head
	
	assert_equal(4, @building.number_of_heads)
	
	@building.remove_all_heads
	
	assert_equal(0, @building.number_of_heads)
  end
  
  def test_extractor_cannot_remove_a_head_it_doesnt_have
	unrelated_extractor_head_instance = ExtractorHead.new
	
	assert_raise RuntimeError do
	  @building.remove_extractor_head(unrelated_extractor_head_instance)
	end
  end
  
  def test_extractor_powergrid_usage_scales_with_heads
	head_one = @building.add_extractor_head
	head_two = @building.add_extractor_head
	head_three = @building.add_extractor_head
	head_four = @building.add_extractor_head
	
	                        # Base + (550 pg per head)
	total_powergrid_usage = (2600 + (550 * @building.number_of_heads))
	
	assert_equal(total_powergrid_usage, @building.powergrid_usage)
  end
  
  def test_extractor_cpu_usage_scales_with_heads
	head_one = @building.add_extractor_head
	head_two = @building.add_extractor_head
	head_three = @building.add_extractor_head
	head_four = @building.add_extractor_head
	
	                # Base + (110 cpu per head)
	total_cpu_usage = (400 + (110 * @building.number_of_heads))
	
	assert_equal(total_cpu_usage, @building.cpu_usage)
  end
  
  def test_extractor_powergrid_provided_does_not_scale_with_heads
	head_one = @building.add_extractor_head
	head_two = @building.add_extractor_head
	head_three = @building.add_extractor_head
	head_four = @building.add_extractor_head
	
	assert_equal(0, @building.powergrid_provided)
  end
  
  def test_extractor_cpu_provided_does_not_scale_with_heads
	head_one = @building.add_extractor_head
	head_two = @building.add_extractor_head
	head_three = @building.add_extractor_head
	head_four = @building.add_extractor_head
	
	assert_equal(0, @building.cpu_provided)
  end
  
  def test_extractor_isk_cost_does_not_scale_with_heads
	head_one = @building.add_extractor_head
	head_two = @building.add_extractor_head
	head_three = @building.add_extractor_head
	head_four = @building.add_extractor_head
	
	assert_equal(45000.00, @building.isk_cost)
  end
  
  def test_extractor_can_tell_us_acceptable_products
	# We should only accept schematics which have a p-level of 0.
	assert_equal(["Carebear Tears"], @building.accepted_product_names)
  end
  
  def test_extractor_can_set_a_product_name_to_extract_and_product_ref_updates
	assert_equal(nil, @building.product_name)
	
	@building.product_name = "Carebear Tears"
	
	assert_equal("Carebear Tears", @building.product_name)
	assert_equal(@@carebear_tears, @building.product)
  end
  
  def test_set_product_shows_right_produces_product_name
	@building.product_name = "Carebear Tears"
	
	assert_equal("Carebear Tears", @building.produces_product_name)
  end
  
  def test_extractor_can_set_a_product_name_to_extract_to_nil_and_product_ref_updates
	@building.product_name = "Carebear Tears"
	
	assert_equal("Carebear Tears", @building.product_name)
	
	@building.product_name = nil
	
	assert_equal(nil, @building.product_name)
	assert_equal(nil, @building.product)
  end
  
  def test_extractor_errors_if_a_p_level_one_or_above_product_is_chosen
	# Can't extract a p-level 1 product.
	assert_raise ArgumentError do
	  @building.product_name = "Pirate Tears"
	end
	
	# Make sure it didn't change.
	assert_equal(nil, @building.product_name)
	assert_equal(nil, @building.product)
  end
  
  def test_extractor_errors_if_a_nonexistant_product_is_chosen
	# Can't extract a p-level 1 product.
	assert_raise ArgumentError do
	  @building.product_name = "Wormhole Tears" # Wormholes don't cry.
	end
	
	# Make sure it didn't change.
	assert_equal(nil, @building.product_name)
	assert_equal(nil, @building.product)
  end
  
  def test_extractor_errors_if_not_given_a_string
	# Can't extract a number.
	assert_raise ArgumentError do
	  @building.product_name = 1236423254
	end
	
	# Make sure it didn't change.
	assert_equal(nil, @building.product_name)
	assert_equal(nil, @building.product)
  end
  
  def test_product_refers_to_product_singleton
	@building.product_name = "Carebear Tears"
	
	assert_equal(@@carebear_tears.object_id, @building.product.object_id)
  end
  
  #
  # Extraction Time
  #
  
  def test_default_extraction_time_is_nil
	assert_equal(nil, @building.extraction_time)
  end
  
  def test_can_set_extraction_time_in_minutes
	# Set extraction time to MAX.
	@building.extraction_time_in_minutes = 20160.0
	
	assert_equal(336.0, @building.extraction_time)
  end
  
  def test_extractor_can_give_us_an_extraction_time_in_minutes
	# Set extraction time to MAX.
	@building.extraction_time = 336.0
	
	assert_equal(20160.0, @building.extraction_time_in_minutes)
  end
  
  def test_can_set_extraction_time_in_hours
	# Set extraction time to MAX.
	@building.extraction_time = 336.0
	
	assert_equal(336.0, @building.extraction_time)
  end
  
  def test_extractor_can_give_us_an_extraction_time_in_hours
	# Set extraction time to MAX.
	@building.extraction_time = 336.0
	
	assert_equal(336.0, @building.extraction_time_in_hours)
  end
  
  def test_extractor_stores_default_extraction_time_in_hours
	# Set extraction time to MAX.
	@building.extraction_time = 336.0
	
	assert_equal(336.0, @building.extraction_time)
  end
  
  def test_can_set_extraction_time_in_days
	# Set extraction time to MAX.
	@building.extraction_time_in_days = 14.0
	
	assert_equal(336.0, @building.extraction_time)
  end
  
  def test_extractor_can_give_us_an_extraction_time_in_days
	# Set extraction time to MAX.
	@building.extraction_time = 336.0
	
	assert_equal(14, @building.extraction_time_in_days)
  end
  
  def test_can_ask_extractor_for_min_extraction_time
	assert_equal(1.0, @building.min_extraction_time)
  end
  
  def test_extractor_does_not_let_user_set_extraction_time_below_sixty_minutes
	# Attempt to set extraction time to 0.5 hours.
	@building.extraction_time = 0.5
	
	# Should set it to the min of 1 hour.
	assert_equal(1.0, @building.extraction_time)
  end
  
  def test_can_ask_extractor_for_max_extraction_time
	assert_equal(336.0, @building.max_extraction_time)
  end
  
  def test_extractor_does_not_let_user_set_extraction_time_above_fourteen_days
	# Attempt to set extraction time to 1000 hours.
	@building.extraction_time = 1000
	
	# Should set it to the max of 14 days (336 hours).
	assert_equal(336.0, @building.extraction_time)
  end
  
  def test_extractor_set_extraction_time_rounds_up_to_fifteen_minute_intervals_between_sixty_minutes_and_twenty_four_and_a_half_hours
	# Attempt to set extraction time to 1.33333 hours.
	@building.extraction_time = 1.33333
	
	# Should round 1.33333 up to 1.5.
	assert_equal(1.5, @building.extraction_time)
	
	# Attempt to set extraction time to 1.66666 hours.
	@building.extraction_time = 1.66666
	
	# Should round 1.66666 up to 1.75.
	assert_equal(1.75, @building.extraction_time)
	
	# Attempt to set extraction time to 1.88888 hours.
	@building.extraction_time = 1.88888
	
	# Should round 1.88888 up to 2.0.
	assert_equal(2.0, @building.extraction_time)
	
	# Attempt to set extraction time to 24.5 hours.
	@building.extraction_time = 24.5
	
	# Should accept 24.5.
	assert_equal(24.5, @building.extraction_time)
	
	# Attempt to set extraction time to 24.88888 hours.
	@building.extraction_time = 24.88888
	
	# Should round up to 25 hours.
	assert_equal(25.0, @building.extraction_time)
  end
  
  def test_extractor_set_extraction_time_rounds_up_to_thirty_minute_intervals_between_twenty_five_hours_and_fourty_nine_and_a_half_hours
	# Attempt to set extraction time to 25.33333 hours.
	@building.extraction_time = 25.33333
	
	# Should round 25.33333 up to 25.5.
	assert_equal(25.5, @building.extraction_time)
	
	# Attempt to set extraction time to 25.66666 hours.
	@building.extraction_time = 25.66666
	
	# Should round 25.66666 up to 26.
	assert_equal(26.0, @building.extraction_time)
	
	# Attempt to set extraction time to 27.25 hours.
	@building.extraction_time = 27.25
	
	# Should round 27.25 up to 27.5.
	assert_equal(27.5, @building.extraction_time)
	
	# Attempt to set extraction time to 49.75 hours.
	@building.extraction_time = 49.75
	
	# Should round 49.75 up to 50.0.
	assert_equal(50.0, @building.extraction_time)
  end
  
  def test_extractor_set_extraction_time_rounds_up_to_one_hour_intervals_between_fifty_hours_and_ninety_nine_and_a_half_hours
	# Attempt to set extraction time to 50.33333 hours.
	@building.extraction_time = 50.33333
	
	# Should round 50.33333 up to 51.
	assert_equal(51.0, @building.extraction_time)
	
	# Attempt to set extraction time to 50.5 hours.
	@building.extraction_time = 50.5
	
	# Should round 50.5 up to 51.
	assert_equal(51.0, @building.extraction_time)
	
	# Attempt to set extraction time to 50.66666 hours.
	@building.extraction_time = 50.66666
	
	# Should round 50.66666 up to 51.
	assert_equal(51.0, @building.extraction_time)
	
	# Attempt to set extraction time to 99.5 hours.
	@building.extraction_time = 99.5
	
	# Should round 99.5 up to 100.
	assert_equal(100.0, @building.extraction_time)
  end
  
  def test_extractor_set_extraction_time_rounds_up_to_two_hour_intervals_between_one_hundred_hours_and_one_hundred_ninety_nine_and_a_half_hours
	# Attempt to set extraction time to 100.5 hours.
	@building.extraction_time = 100.5
	
	# Should round 100.5 up to 102.
	assert_equal(102.0, @building.extraction_time)
	
	# Attempt to set extraction time to 101 hours.
	@building.extraction_time = 101.0
	
	# Should round 101.0 up to 102.
	assert_equal(102.0, @building.extraction_time)
	
	# Attempt to set extraction time to 198.1 hours.
	@building.extraction_time = 198.1
	
	# Should round 198.1 up to 200.
	assert_equal(200.0, @building.extraction_time)
  end
  
  def test_extractor_set_extraction_time_rounds_up_to_four_hour_intervals_between_two_hundred_hours_and_fourteen_days
	# Attempt to set extraction time to 202.0 hours.
	@building.extraction_time = 202.0
	
	# Should round 202.0 up to 204.
	assert_equal(204.0, @building.extraction_time)
	
	# Attempt to set extraction time to 203 hours.
	@building.extraction_time = 203.0
	
	# Should round 203.0 up to 204.
	assert_equal(204.0, @building.extraction_time)
	
	# Attempt to set extraction time to 332.1 hours.
	@building.extraction_time = 332.1
	
	# Should round 332.1 up to 336.
	assert_equal(336.0, @building.extraction_time)
  end
  
  #
  # Cycle Time
  #
  
  def test_extractor_default_cycle_time_is_nil
	assert_equal(nil, @building.cycle_time)
  end
  
  def test_extractor_can_give_us_a_cycle_time_in_minutes
	# Set extraction time to MAX.
	@building.extraction_time = 336.0
	
	# 4 hours * 60 minutes = 240.
	assert_equal(240.0, @building.cycle_time_in_minutes)
  end
  
  def test_extractor_can_give_us_a_cycle_time_in_hours
	# Set extraction time to MAX.
	@building.extraction_time = 336.0
	
	# 4 hours * 1 hour = 4.
	assert_equal(4.0, @building.cycle_time_in_hours)
  end
  
  def test_extractor_stores_default_cycle_time_in_hours
	# Set extraction time to MAX.
	@building.extraction_time = 336.0
	
	# 4 hours * 60 minutes = 240.
	assert_equal(4.0, @building.cycle_time)
  end
  
  def test_extractor_can_give_us_a_cycle_time_in_days
	# Set extraction time to MAX.
	@building.extraction_time = 336.0
	
	# 4 hours / 24 hours = 0.16666666666666666.
	assert_equal(0.16666666666666666, @building.cycle_time_in_days)
  end
  
  def test_extractor_does_not_let_user_change_cycle_time
	assert_false(@building.respond_to?(:cycle_time=))
  end
  
  def test_extractor_cycle_time_scales_with_extraction_time
	# If extraction time is > 60 minutes and < 25 hours
	# Cycle time should be 15 minutes.
	@building.extraction_time = 12.0
	assert_equal(0.25, @building.cycle_time)
	
	# If extraction time is > 25 hours and < 50 hours
	# Cycle time should be 30 minutes.
	@building.extraction_time = 40.0
	assert_equal(0.5, @building.cycle_time)
	
	# If extraction time is > 50 hours and < 100 hours
	# Cycle time should be 1 hour.
	@building.extraction_time = 75.0
	assert_equal(1.0, @building.cycle_time)
	
	# If extraction time is > 100 hours and < 200 hours
	# Cycle time should be 2 hours.
	@building.extraction_time = 150.0
	assert_equal(2.0, @building.cycle_time)
	
	# If extraction time is > 200 hours
	# Cycle time should be 4 hours.
	@building.extraction_time = 250.0
	assert_equal(4.0, @building.cycle_time)
  end
  
  # 
  # "Observable" tests
  # 
  
  def test_extractor_is_observable
	assert_true(@building.is_a?(Observable), "Extractor did not include Observable.")
  end
  
  # Update method for testing observer.
  def update
	@was_notified_of_change = true
  end
  
  def test_extractor_notifies_observers_when_a_head_is_added
	@building.add_observer(self)
	
	@building.add_extractor_head
	
	assert_true(@was_notified_of_change, "Extractor did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_extractor_notifies_observers_when_a_head_is_removed
	
	head_one = @building.add_extractor_head
	
	@building.add_observer(self)
	
	@building.remove_extractor_head(head_one)
	
	assert_true(@was_notified_of_change, "Extractor did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_extractor_does_not_notify_observers_when_a_head_is_added_but_fails
	10.times do
	  @building.add_extractor_head
	end
	
	@building.add_observer(self)
	
	assert_raise RuntimeError do
	  @building.add_extractor_head
	end
	
	assert_false(@was_notified_of_change, "Extractor called notify_observers when its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_extractor_does_not_notify_observers_when_a_head_is_removed_but_fails
	unrelated_extractor_head_instance = ExtractorHead.new
	
	@building.add_observer(self)
	
	assert_raise RuntimeError do
	  @building.remove_extractor_head(unrelated_extractor_head_instance)
	end
	
	assert_false(@was_notified_of_change, "Extractor called notify_observers when its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_extractor_notifies_observers_when_all_heads_are_removed
	head_one = @building.add_extractor_head
	head_two = @building.add_extractor_head
	head_three = @building.add_extractor_head
	head_four = @building.add_extractor_head
	
	assert_equal(4, @building.number_of_heads)
	
	@building.add_observer(self)
	
	@building.remove_all_heads
	
	assert_true(@was_notified_of_change, "Extractor did not call notify_observers or its state did not change.")
	
	assert_equal(0, @building.number_of_heads)
	
	@building.delete_observer(self)
  end
  
  def test_extractor_notifies_observers_when_its_product_changes
	@building.add_observer(self)
	
	@building.product_name = "Carebear Tears"
	
	assert_true(@was_notified_of_change, "Extractor did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_extractor_notifies_observers_when_its_product_is_set_to_nil
	@building.product_name = "Carebear Tears"
	
	@building.add_observer(self)
	
	@building.product_name = nil
	
	assert_true(@was_notified_of_change, "Extractor did not call notify_observers or its state did not change.")
	
	@building.delete_observer(self)
  end
  
  def test_extractor_does_not_notify_observers_when_its_product_is_set_but_fails
	@building.add_observer(self)
	
	# Should fail because Pirate Tears are P1s.
	assert_raise ArgumentError do
	  @building.product_name = "Pirate Tears"
	end
	assert_false(@was_notified_of_change, "Extractor called notify_observers when its state did not change.")
	
	# Should fail because Wormholes don't cry. And this product doesn't exist.
	assert_raise ArgumentError do
	  @building.product_name = "Wormhole Tears"
	end
	assert_false(@was_notified_of_change, "Extractor called notify_observers when its state did not change.")
	
	# Should fail because it isn't a valid name.
	assert_raise ArgumentError do
	  @building.product_name = 1236423254
	end
	assert_false(@was_notified_of_change, "Extractor called notify_observers when its state did not change.")
	
	assert_equal(nil, @building.product_name)
	
	@building.delete_observer(self)
  end
  
  def test_extractor_does_not_notify_observers_when_its_product_is_set_but_doesnt_change
	assert_equal(nil, @building.product_name)
	
	@building.add_observer(self)
	
	@building.product_name = nil
	
	assert_equal(nil, @building.product_name)
	assert_false(@was_notified_of_change, "Extractor called notify_observers when its state did not change.")
	
	@building.delete_observer(self)
  end
end