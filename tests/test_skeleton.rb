require "test/unit"

# require_relative "class_to_test.rb"

class TestCaseSkeleton < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_something
	#assert_equal("A", "A")
	#assert_true(true)
	#assert_false(false)
	#assert_raise SomethingError do
	  #assert_equal("A", "B")
	#end
  end
  
  def test_something_else
  end
end