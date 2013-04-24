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