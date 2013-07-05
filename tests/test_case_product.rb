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
	# Should have all the objects we created during self.setup.
	assert_true(Product.all.include?(@@snip))
	assert_true(Product.all.include?(@@snail))
	assert_true(Product.all.include?(@@puppy_dog_tail))
	assert_true(Product.all.include?(@@boy))
	
	# Should have no more than the objects we created during self.setup.
	assert_equal(4, Product.all.count)
  end
  
  def test_can_delete_products
	# At this point we should have no more than the objects we created during self.setup.
	assert_equal(4, Product.all.count)
	
	# Create the product.
	sneakers = Product.new("Sneakers", 0)
	
	# At this point we should have one extra product.
	assert_equal(5, Product.all.count)
	assert_true(Product.all.include?(sneakers))
	
	# Delete the product.
	Product.delete(sneakers)
	
	assert_false(Product.all.include?(sneakers))
	assert_equal(4, Product.all.count)
  end
  
  def test_find_or_create
	# If a product exists, make sure we find it.
	assert_equal(@@snip, Product.find_or_create("Snip", 0))
	assert_equal(@@snail, Product.find_or_create("Snail", 0))
	assert_equal(@@puppy_dog_tail, Product.find_or_create("Puppy Dog Tail", 0))
	
	# At this point we should have no more than the objects we created during self.setup.
	assert_equal(4, Product.all.count)
	
	# If a product doesn't exist, make sure we create it.
	sneakers = Product.find_or_create("Sneakers", 0)
	
	assert_true(sneakers.is_a?(Product))
	assert_equal("Sneakers", sneakers.name)
	assert_equal(0, sneakers.p_level)
	
	# At this point we should one extra product.
	assert_equal(5, Product.all.count)
	assert_true(Product.all.include?(sneakers))
	
	# Make sure we can find the new product.
	found_sneakers = Product.find_or_create("Sneakers", 0)
	assert_equal(sneakers, found_sneakers)
	
	# Clean up after ourselves.
	Product.delete(sneakers)
	
	# At this point we should have no more than the objects we created during self.setup.
	assert_equal(4, Product.all.count)
	assert_false(Product.all.include?(sneakers))
  end
  
  def test_can_search_for_products_by_name
	found_snip_product = Product.find_by_name("Snip")
	
	# Should return @@snip.
	assert_equal(@@snip, found_snip_product)
  end
  
  def test_can_search_for_products_by_p_level
	# P0
	list_of_p_zero_products = Product.find_by_p_level(0)
	
	# Should have all the p_zero objects we created during self.setup.
	assert_true(list_of_p_zero_products.include?(@@snip))
	assert_true(list_of_p_zero_products.include?(@@snail))
	assert_true(list_of_p_zero_products.include?(@@puppy_dog_tail))
	
	# Should have no more than the p_zero objects we created during self.setup.
	assert_equal(3, list_of_p_zero_products.count)
	
	# P1
	list_of_p_one_products = Product.find_by_p_level(1)
	
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
  
  def test_import_cost_scales_with_p_level
	@@snip.set_p_level(0)
	assert_equal(2.50, @@snip.import_cost)
	
	@@snip.set_p_level(1)
	assert_equal(250.00, @@snip.import_cost)
	
	@@snip.set_p_level(2)
	assert_equal(4500.00, @@snip.import_cost)
	
	@@snip.set_p_level(3)
	assert_equal(35000.00, @@snip.import_cost)
	
	@@snip.set_p_level(4)
	assert_equal(675000.00, @@snip.import_cost)
	
	# Reset to 0.
	@@snip.set_p_level(0)
  end
  
  def test_export_cost_scales_with_p_level
	@@snip.set_p_level(0)
	assert_equal(5.00, @@snip.export_cost)
	
	@@snip.set_p_level(1)
	assert_equal(500.00, @@snip.export_cost)
	
	@@snip.set_p_level(2)
	assert_equal(9000.00, @@snip.export_cost)
	
	@@snip.set_p_level(3)
	assert_equal(70000.00, @@snip.export_cost)
	
	@@snip.set_p_level(4)
	assert_equal(1350000.00, @@snip.export_cost)
	
	# Reset to 0.
	@@snip.set_p_level(0)
  end
  
  def test_import_cost_for_quantity_errors_if_given_non_numeric
	assert_raise ArgumentError do
	  @@snip.import_cost_for_quantity(nil)
	end
	
	assert_raise ArgumentError do
	  @@snip.import_cost_for_quantity("fail")
	end
  end
  
  def test_export_cost_for_quantity_errors_if_given_non_numeric
	assert_raise ArgumentError do
	  @@snip.export_cost_for_quantity(nil)
	end
	
	assert_raise ArgumentError do
	  @@snip.export_cost_for_quantity("fail")
	end
  end
  
  def test_import_cost_for_quantity_scales_with_p_level
	@@snip.set_p_level(0)
	assert_equal(25.00, @@snip.import_cost_for_quantity(10))
	
	@@snip.set_p_level(1)
	assert_equal(2500.00, @@snip.import_cost_for_quantity(10))
	
	@@snip.set_p_level(2)
	assert_equal(45000.00, @@snip.import_cost_for_quantity(10))
	
	@@snip.set_p_level(3)
	assert_equal(350000.00, @@snip.import_cost_for_quantity(10))
	
	@@snip.set_p_level(4)
	assert_equal(6750000.00, @@snip.import_cost_for_quantity(10))
	
	# Reset to 0.
	@@snip.set_p_level(0)
  end
  
  def test_export_cost_for_quantity_scales_with_p_level
	@@snip.set_p_level(0)
	assert_equal(50.00, @@snip.export_cost_for_quantity(10))
	
	@@snip.set_p_level(1)
	assert_equal(5000.00, @@snip.export_cost_for_quantity(10))
	
	@@snip.set_p_level(2)
	assert_equal(90000.00, @@snip.export_cost_for_quantity(10))
	
	@@snip.set_p_level(3)
	assert_equal(700000.00, @@snip.export_cost_for_quantity(10))
	
	@@snip.set_p_level(4)
	assert_equal(13500000.00, @@snip.export_cost_for_quantity(10))
	
	# Reset to 0.
	@@snip.set_p_level(0)
  end
end