require "test/unit"

require_relative "../model/product.rb"

class TestCaseProduct < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@product = Product.new("Snip", 0)
  end
  
  # Run once after every test.
  def teardown
  end
  
  def test_set_p_level
	assert_equal(0, @product.p_level)
	
	@product.set_p_level(1)
	
	assert_equal(1, @product.p_level)
  end

  def test_cannot_set_p_level_below_zero
	assert_equal(0, @product.p_level)
	
	assert_raise ArgumentError do
	  @product.set_p_level(-1)
	end
	
	assert_raise ArgumentError do
	  @product.set_p_level(-12)
	end
	
	assert_raise ArgumentError do
	  @product.set_p_level(-1236423254)
	end
	
	assert_equal(0, @product.p_level)
  end
  
  def test_cannot_set_p_level_above_four
	assert_equal(0, @product.p_level)
	
	assert_raise ArgumentError do
	  @product.set_p_level(5)
	end
	
	assert_raise ArgumentError do
	  @product.set_p_level(12)
	end
	
	assert_raise ArgumentError do
	  @product.set_p_level(1236423254)
	end
	
	assert_equal(0, @product.p_level)
  end
  
  def test_volume_scales_with_p_level
	@product.set_p_level(0)
	assert_equal(0.01, @product.volume)
	
	@product.set_p_level(1)
	assert_equal(0.38, @product.volume)
	
	@product.set_p_level(2)
	assert_equal(1.50, @product.volume)
	
	@product.set_p_level(3)
	assert_equal(6.00, @product.volume)
	
	@product.set_p_level(4)
	assert_equal(100, @product.volume)
  end
end