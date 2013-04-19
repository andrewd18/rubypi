require "test/unit"

require_relative "../model/product.rb"

class TestCaseProduct < Test::Unit::TestCase
  # Run once.
  def self.startup
	@@snip = Product.new("Snip", 0)
	@@snail = Product.new("Snail", 0)
	@@puppy_dog_tail = Product.new("Puppy Dog Tail", 0)
	@@boy = Product.new("Boy", 1)
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
  end
  
  # Run once after every test.
  def teardown
  end
  
  def test_error_on_product_creation_if_name_taken
	duplicate_product = nil
	
	assert_raise ArgumentError do
	  duplicate_product = Product.new("Snip", 0)
	end
	
	# Make sure duplicate_product didn't get assigned.
	assert_equal(nil, duplicate_product)
  end
  
  def test_error_on_product_creation_if_p_level_below_zero
	sugar = nil
	
	assert_raise ArgumentError do
	  sugar = Product.new("Sugar", -1)
	end
	
	assert_raise ArgumentError do
	  sugar = Product.new("Sugar", -12)
	end
	
	assert_raise ArgumentError do
	  sugar = Product.new("Sugar", -1236423254)
	end
	
	# Make sure sugar didn't get assigned.
	assert_equal(nil, sugar)
  end
  
  def test_error_on_product_creation_if_p_level_above_four
	sugar = nil
	
	assert_raise ArgumentError do
	  sugar = Product.new("Sugar", 5)
	end
	
	assert_raise ArgumentError do
	  sugar = Product.new("Sugar", 12)
	end
	
	assert_raise ArgumentError do
	  sugar = Product.new("Sugar", 1236423254)
	end
	
	# Make sure sugar didn't get assigned.
	assert_equal(nil, sugar)
  end
  
  def test_creating_a_product_only_adds_one_product_to_instances
	list_of_product_instances = Product.all
	
	# Should have all the objects we created during self.setup.
	assert_true(list_of_product_instances.include?(@@snip))
	assert_true(list_of_product_instances.include?(@@snail))
	assert_true(list_of_product_instances.include?(@@puppy_dog_tail))
	assert_true(list_of_product_instances.include?(@@boy))
	
	# Should have no more than the objects we created during self.setup.
	assert_equal(4, list_of_product_instances.count)
  end
  
  def test_can_search_for_products_by_name
	found_snip_product = Product.find_product_by_name("Snip")
	
	# Should return @@snip.
	assert_equal(@@snip, found_snip_product)
  end
  
  def test_can_search_for_products_by_p_level
	# P0
	list_of_p_zero_products = Product.find_products_by_p_level(0)
	
	# Should have all the p_zero objects we created during self.setup.
	assert_true(list_of_p_zero_products.include?(@@snip))
	assert_true(list_of_p_zero_products.include?(@@snail))
	assert_true(list_of_p_zero_products.include?(@@puppy_dog_tail))
	
	# Should have no more than the p_zero objects we created during self.setup.
	assert_equal(3, list_of_p_zero_products.count)
	
	# P1
	list_of_p_one_products = Product.find_products_by_p_level(1)
	
	# Should have all the objects we created during self.setup.
	assert_true(list_of_p_one_products.include?(@@boy))
	
	# Should have no more than the objects we created during self.setup.
	assert_equal(1, list_of_p_one_products.count)
  end
  
  def test_set_p_level
	assert_equal(0, @@snip.p_level)
	
	@@snip.set_p_level(1)
	
	assert_equal(1, @@snip.p_level)
	
	# Set back to 0.
	@@snip.set_p_level(0)
	
	assert_equal(0, @@snip.p_level)
  end

  def test_cannot_set_p_level_below_zero
	assert_equal(0, @@snip.p_level)
	
	assert_raise ArgumentError do
	  @@snip.set_p_level(-1)
	end
	
	assert_raise ArgumentError do
	  @@snip.set_p_level(-12)
	end
	
	assert_raise ArgumentError do
	  @@snip.set_p_level(-1236423254)
	end
	
	assert_equal(0, @@snip.p_level)
  end
  
  def test_cannot_set_p_level_above_four
	assert_equal(0, @@snip.p_level)
	
	assert_raise ArgumentError do
	  @@snip.set_p_level(5)
	end
	
	assert_raise ArgumentError do
	  @@snip.set_p_level(12)
	end
	
	assert_raise ArgumentError do
	  @@snip.set_p_level(1236423254)
	end
	
	assert_equal(0, @@snip.p_level)
  end
  
  def test_volume_scales_with_p_level
	@@snip.set_p_level(0)
	assert_equal(0.01, @@snip.volume)
	
	@@snip.set_p_level(1)
	assert_equal(0.38, @@snip.volume)
	
	@@snip.set_p_level(2)
	assert_equal(1.50, @@snip.volume)
	
	@@snip.set_p_level(3)
	assert_equal(6.00, @@snip.volume)
	
	@@snip.set_p_level(4)
	assert_equal(100, @@snip.volume)
	
	# Reset to 0.
	@@snip.set_p_level(0)
  end
  
  def test_import_export_cost_scales_with_p_level
	@@snip.set_p_level(0)
	assert_equal(5.00, @@snip.base_import_export_cost)
	
	@@snip.set_p_level(1)
	assert_equal(500.00, @@snip.base_import_export_cost)
	
	@@snip.set_p_level(2)
	assert_equal(9000.00, @@snip.base_import_export_cost)
	
	@@snip.set_p_level(3)
	assert_equal(70000.00, @@snip.base_import_export_cost)
	
	@@snip.set_p_level(4)
	assert_equal(1350000.00, @@snip.base_import_export_cost)
	
	# Reset to 0.
	@@snip.set_p_level(0)
  end
end