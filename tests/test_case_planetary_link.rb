require "test/unit"

require_relative "../model/planetary_link.rb"

class TestCasePlanetaryLink < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@link = PlanetaryLink.new
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
  
  
  
  
  def test_can_read_link_level
	assert_equal(0, @link.upgrade_level)
  end
  
  def test_can_increase_link_level
	assert_equal(0, @link.upgrade_level)
	
	@link.increase_level
	
	assert_equal(1, @link.upgrade_level)
  end
  
  def test_link_level_does_not_go_above_ten
	assert_equal(0, @link.upgrade_level)
	
	10.times do
	  @link.increase_level
	end
	
	assert_equal(10, @link.upgrade_level)
	
	@link.increase_level
	
	assert_equal(10, @link.upgrade_level)
  end
  
  def test_can_downgrade_link_level
	assert_equal(0, @link.upgrade_level)
	
	10.times do
	  @link.increase_level
	end
	
	assert_equal(10, @link.upgrade_level)
	
	@link.decrease_level
	
	assert_equal(9, @link.upgrade_level)
  end
  
  def test_link_level_does_not_go_below_zero
	assert_equal(0, @link.upgrade_level)
	
	@link.decrease_level
	
	assert_equal(0, @link.upgrade_level)
  end
  
  def test_can_set_link_level
	assert_equal(0, @link.upgrade_level)
	
	@link.upgrade_level = 5
	
	assert_equal(5, @link.upgrade_level)
  end
  
  def test_cannot_set_link_level_below_zero
	assert_equal(0, @link.upgrade_level)
	
	@link.upgrade_level = (-5)
	
	assert_equal(0, @link.upgrade_level)
  end
  
  def test_cannot_set_link_level_above_ten
	assert_equal(0, @link.upgrade_level)
	
	@link.upgrade_level = 11
	
	assert_equal(0, @link.upgrade_level)
  end
  
  def test_can_read_link_length
	# Minimum is 2 km.
	assert_equal(2, @link.length)
  end
  
  def test_can_set_link_length
	assert_equal(2, @link.length)
	
	@link.length = 500
	
	assert_equal(500, @link.length)
  end
  
  def test_cannot_set_link_length_below_two_km
	assert_equal(2, @link.length)
	
	@link.length = 1
	
	assert_equal(2, @link.length)
  end
  
  def test_cannot_set_link_length_above_forty_thousand_km
	assert_equal(2, @link.length)
	
	@link.length = 40001
	
	assert_equal(2, @link.length)
  end
  
  def test_base_link_pg_used_is_ten
	assert_equal(10, @link.powergrid_usage)
  end
  
  def test_base_link_cpu_usage_is_fifteen
	assert_equal(15, @link.cpu_usage)
  end
  
  def test_link_powergrid_provided_is_zero
	assert_equal(0, @link.powergrid_provided)
  end
  
  def test_link_cpu_provided_is_zero
	assert_equal(0, @link.cpu_provided)
  end
  
  # TODO - Not sure if links are free.
  def test_base_isk_cost_is_zero
	assert_equal(0, @link.isk_cost)
  end
  
  def test_base_transfer_volume_is_two_hundred_fifty_meters_cubed
	assert_equal(250, @link.transfer_volume)
  end
  
  def test_pg_used_scales_with_link_level
	pend
  end
  

  def test_cpu_usage_scales_with_link_level
	pend
  end

  # In addition to the base rate to build a link (10 PG+15 CPU), it also costs 0.20 cpu and 0.15 power per kilometer. 
  def test_pg_usage_scales_with_link_length
	pend
	assert_equal(2, @link.length)
	assert_equal(10, @link.powergrid_usage)
	
	# Scale according to http://wiki.eveuniversity.org/Planetary_Buildings#Planetary_Links
	# BUG - That article is full of shit as this doesn't scale evenly at all.
	#       Unless it scales unevenly like cycle time. Grr.
	@link.length = 2.5
	assert_equal(11, @link.powergrid_usage)
	
	@link.length = 10
	assert_equal(12, @link.powergrid_usage)
	
	@link.length = 20
	assert_equal(14, @link.powergrid_usage)
	
	@link.length = 50
	assert_equal(18, @link.powergrid_usage)
	
	@link.length = 100
	assert_equal(26, @link.powergrid_usage)
	
	@link.length = 200
	assert_equal(41, @link.powergrid_usage)
	
	@link.length = 500
	assert_equal(86, @link.powergrid_usage)
	
	@link.length = 1000
	assert_equal(160, @link.powergrid_usage)
	
	@link.length = 2000
	assert_equal(311, @link.powergrid_usage)
	
	@link.length = 5000
	assert_equal(761, @link.powergrid_usage)
	
	@link.length = 40000
	assert_equal(6001, @link.powergrid_usage)
  end
  
  # In addition to the base rate to build a link (10 PG+15 CPU), it also costs 0.20 cpu and 0.15 power per kilometer. 
  def test_cpu_usage_scales_with_link_length
	pend
	# Default
	assert_equal(2, @link.length)
	assert_equal(15, @link.cpu_usage)
	
	# Scale according to http://wiki.eveuniversity.org/Planetary_Buildings#Planetary_Links
	# BUG - That article is full of shit as this doesn't scale evenly at all.
	#       Unless it scales unevenly like cycle time. Grr.
	@link.length = 2.5
	assert_equal(16, @link.cpu_usage)
	
	@link.length = 10
	assert_equal(18, @link.cpu_usage)
	
	@link.length = 20
	assert_equal(20, @link.cpu_usage)
	
	@link.length = 50
	assert_equal(26, @link.cpu_usage)
	
	@link.length = 100
	assert_equal(36, @link.cpu_usage)
	
	@link.length = 200
	assert_equal(56, @link.cpu_usage)
	
	@link.length = 500
	assert_equal(116, @link.cpu_usage)
	
	@link.length = 1000
	assert_equal(215, @link.cpu_usage)
	
	@link.length = 2000
	assert_equal(416, @link.cpu_usage)
	
	@link.length = 5000
	assert_equal(1016, @link.cpu_usage)
	
	@link.length = 40000
	assert_equal(8016, @link.cpu_usage)
  end
  
  # TODO - Not sure if links are free.
  def test_isk_cost_does_not_scale_with_link_length
	@link.length = 40000
	
	assert_equal(0, @link.isk_cost)
  end
  
  def test_transfer_volume_scales_with_link_level
	pend
  end
  
  def test_transfer_volume_does_not_scale_with_link_length
	pend
  end
end