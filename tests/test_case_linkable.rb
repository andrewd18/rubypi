require "test/unit"

require_relative "../model/planet.rb"
require_relative "../model/linkable.rb"

class LinkableStub
  include Linkable
  
  attr_reader :planet
  
  def initialize(planet)
	@planet = planet
  end
end

class TestCaseLinkable < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@planet = Planet.new("Lava")
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_can_find_links_connected_to_self
	stub_one = LinkableStub.new(@planet)
	stub_two = LinkableStub.new(@planet)
	stub_three = LinkableStub.new(@planet)
	stub_four = LinkableStub.new(@planet)
	stub_five = LinkableStub.new(@planet)
	stub_six = LinkableStub.new(@planet)
	
	# Connect stub_one to all other stubs.
	one_two_link = @planet.add_link(stub_one, stub_two)
	one_three_link = @planet.add_link(stub_one, stub_three)
	one_four_link = @planet.add_link(stub_one, stub_four)
	one_five_link = @planet.add_link(stub_one, stub_five)
	one_six_link = @planet.add_link(stub_one, stub_six)
	
	list_of_links = stub_one.links
	
	assert_true(list_of_links.include?(one_two_link))
	assert_true(list_of_links.include?(one_three_link))
	assert_true(list_of_links.include?(one_four_link))
	assert_true(list_of_links.include?(one_five_link))
	assert_true(list_of_links.include?(one_six_link))
  end
  
  def test_num_links_scales_with_links
	stub_one = LinkableStub.new(@planet)
	stub_two = LinkableStub.new(@planet)
	stub_three = LinkableStub.new(@planet)
	stub_four = LinkableStub.new(@planet)
	stub_five = LinkableStub.new(@planet)
	stub_six = LinkableStub.new(@planet)
	
	# Connect stub_one to all other stubs.
	@planet.add_link(stub_one, stub_two)
	@planet.add_link(stub_one, stub_three)
	@planet.add_link(stub_one, stub_four)
	@planet.add_link(stub_one, stub_five)
	@planet.add_link(stub_one, stub_six)
	
	assert_equal(5, stub_one.num_links)
	assert_equal(1, stub_two.num_links)
	assert_equal(1, stub_three.num_links)
	assert_equal(1, stub_four.num_links)
	assert_equal(1, stub_five.num_links)
	assert_equal(1, stub_six.num_links)
  end
  
  def test_can_find_buildings_connected_to_self_through_links
	stub_one = LinkableStub.new(@planet)
	stub_two = LinkableStub.new(@planet)
	stub_three = LinkableStub.new(@planet)
	stub_four = LinkableStub.new(@planet)
	stub_five = LinkableStub.new(@planet)
	stub_six = LinkableStub.new(@planet)
	
	# Connect stub_one to all other stubs.
	@planet.add_link(stub_one, stub_two)
	@planet.add_link(stub_one, stub_three)
	@planet.add_link(stub_one, stub_four)
	@planet.add_link(stub_one, stub_five)
	@planet.add_link(stub_one, stub_six)
	
	linked_buildings = stub_one.linked_buildings
	
	assert_true(linked_buildings.include?(stub_two))
	assert_true(linked_buildings.include?(stub_three))
	assert_true(linked_buildings.include?(stub_four))
	assert_true(linked_buildings.include?(stub_five))
	assert_true(linked_buildings.include?(stub_six))
  end
  
  def test_num_linked_buildings_scales_with_linked_buildings
	stub_one = LinkableStub.new(@planet)
	stub_two = LinkableStub.new(@planet)
	stub_three = LinkableStub.new(@planet)
	stub_four = LinkableStub.new(@planet)
	stub_five = LinkableStub.new(@planet)
	stub_six = LinkableStub.new(@planet)
	
	# Connect stub_one to all other stubs.
	@planet.add_link(stub_one, stub_two)
	@planet.add_link(stub_one, stub_three)
	@planet.add_link(stub_one, stub_four)
	@planet.add_link(stub_one, stub_five)
	@planet.add_link(stub_one, stub_six)
	
	assert_equal(5, stub_one.num_linked_buildings)
	assert_equal(1, stub_two.num_linked_buildings)
	assert_equal(1, stub_three.num_linked_buildings)
	assert_equal(1, stub_four.num_linked_buildings)
	assert_equal(1, stub_five.num_linked_buildings)
	assert_equal(1, stub_six.num_linked_buildings)
  end
end