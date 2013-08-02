require "test/unit"

require_relative "../model/planet.rb"
require_relative "../model/storage_facility.rb"
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
	@planet = Planet.new("Lava")
	@storage_facility_a = StorageFacility.new(1.2, 3.4)
	@storage_facility_b = StorageFacility.new(5.6, 7.8)
	@storage_facility_a.planet = @planet
	@storage_facility_b.planet = @planet
	
	@link = PlanetaryLink.new(@planet, @storage_facility_a, @storage_facility_b)
	
	# Observable variables.
	@was_notified_of_change = false
  end
  
  # Run after every test.
  def teardown
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
  
  def test_base_transfer_volume_is_two_hundred_fifty_meters_cubed
	assert_equal(250, @link.transfer_volume)
  end
  
  def test_pg_used_scales_with_link_level
	pend("Waiting on research about how this should actually scale.")
  end
  
  def test_cpu_usage_scales_with_link_level
	pend("Waiting on research about how this should actually scale.")
  end

  def test_pg_usage_scales_with_link_length
	# Scale according to the table at http://wiki.eveuniversity.org/Planetary_Buildings#Planetary_Links
	#
	# PG Cost = ((Link Length * 0.15) + Base PG Cost of 10)
	# 
	# While not perfectly accurate (off by 9 pg at 40,000 km), it's "close enough" as of Odyssey 1.0.10
	
	# I only test against truncated values here because while EVE may use floats in the background,
	# it displays ints in the UI.
	
	@link.length = 2.5
	expected_value = (@link.length * 0.15 + PlanetaryLink::BASE_POWERGRID_USAGE)
	assert_equal(expected_value.to_int, @link.powergrid_usage)
	
	@link.length = 10
	expected_value = (@link.length * 0.15 + PlanetaryLink::BASE_POWERGRID_USAGE)
	assert_equal(expected_value.to_int, @link.powergrid_usage)
	
	@link.length = 20
	expected_value = (@link.length * 0.15 + PlanetaryLink::BASE_POWERGRID_USAGE)
	assert_equal(expected_value.to_int, @link.powergrid_usage)
	
	@link.length = 50
	expected_value = (@link.length * 0.15 + PlanetaryLink::BASE_POWERGRID_USAGE)
	assert_equal(expected_value.to_int, @link.powergrid_usage)
	
	@link.length = 100
	expected_value = (@link.length * 0.15 + PlanetaryLink::BASE_POWERGRID_USAGE)
	assert_equal(expected_value.to_int, @link.powergrid_usage)
	
	@link.length = 200
	expected_value = (@link.length * 0.15 + PlanetaryLink::BASE_POWERGRID_USAGE)
	assert_equal(expected_value.to_int, @link.powergrid_usage)
	
	@link.length = 500
	expected_value = (@link.length * 0.15 + PlanetaryLink::BASE_POWERGRID_USAGE)
	assert_equal(expected_value.to_int, @link.powergrid_usage)
	
	@link.length = 1000
	expected_value = (@link.length * 0.15 + PlanetaryLink::BASE_POWERGRID_USAGE)
	assert_equal(expected_value.to_int, @link.powergrid_usage)
	
	@link.length = 2000
	expected_value = (@link.length * 0.15 + PlanetaryLink::BASE_POWERGRID_USAGE)
	assert_equal(expected_value.to_int, @link.powergrid_usage)
	
	@link.length = 5000
	expected_value = (@link.length * 0.15 + PlanetaryLink::BASE_POWERGRID_USAGE)
	assert_equal(expected_value.to_int, @link.powergrid_usage)
	
	@link.length = 40000
	expected_value = (@link.length * 0.15 + PlanetaryLink::BASE_POWERGRID_USAGE)
	assert_equal(expected_value.to_int, @link.powergrid_usage)
  end
  
  # In addition to the base rate to build a link (10 PG+15 CPU), it also costs 0.20 cpu and 0.15 power per kilometer. 
  def test_cpu_usage_scales_with_link_length
	# Scale according to the table at http://wiki.eveuniversity.org/Planetary_Buildings#Planetary_Links
	#
	# CPU Cost = ((Link Length * 0.20) + Base CPU Cost of 15)
	# 
	# While not perfectly accurate (off by 1 CPU at 40,000 km), it's "close enough" as of Odyssey 1.0.10
	
	# I only test against truncated values here because while EVE may use floats in the background,
	# it displays ints in the UI.
	
	@link.length = 2.5
	expected_value = (@link.length * 0.20 + PlanetaryLink::BASE_CPU_USAGE)
	assert_equal(expected_value.to_int, @link.cpu_usage)
	
	@link.length = 10
	expected_value = (@link.length * 0.20 + PlanetaryLink::BASE_CPU_USAGE)
	assert_equal(expected_value.to_int, @link.cpu_usage)
	
	@link.length = 20
	expected_value = (@link.length * 0.20 + PlanetaryLink::BASE_CPU_USAGE)
	assert_equal(expected_value.to_int, @link.cpu_usage)
	
	@link.length = 50
	expected_value = (@link.length * 0.20 + PlanetaryLink::BASE_CPU_USAGE)
	assert_equal(expected_value.to_int, @link.cpu_usage)
	
	@link.length = 100
	expected_value = (@link.length * 0.20 + PlanetaryLink::BASE_CPU_USAGE)
	assert_equal(expected_value.to_int, @link.cpu_usage)
	
	@link.length = 200
	expected_value = (@link.length * 0.20 + PlanetaryLink::BASE_CPU_USAGE)
	assert_equal(expected_value.to_int, @link.cpu_usage)
	
	@link.length = 500
	expected_value = (@link.length * 0.20 + PlanetaryLink::BASE_CPU_USAGE)
	assert_equal(expected_value.to_int, @link.cpu_usage)
	
	@link.length = 1000
	expected_value = (@link.length * 0.20 + PlanetaryLink::BASE_CPU_USAGE)
	assert_equal(expected_value.to_int, @link.cpu_usage)
	
	@link.length = 2000
	expected_value = (@link.length * 0.20 + PlanetaryLink::BASE_CPU_USAGE)
	assert_equal(expected_value.to_int, @link.cpu_usage)
	
	@link.length = 5000
	expected_value = (@link.length * 0.20 + PlanetaryLink::BASE_CPU_USAGE)
	assert_equal(expected_value.to_int, @link.cpu_usage)
	
	@link.length = 40000
	expected_value = (@link.length * 0.20 + PlanetaryLink::BASE_CPU_USAGE)
	assert_equal(expected_value.to_int, @link.cpu_usage)
  end
  
  def test_isk_cost_is_zero
	# Links cost nothing to buy or to upgrade
	assert_equal(0, @link.isk_cost)
  end
  
  def test_transfer_volume_scales_with_link_level
	pend("Waiting on research about how this should actually scale.")
  end
  
  def test_transfer_volume_does_not_scale_with_link_length
	pend("Waiting on research about how this should actually scale.")
  end
  
  def test_a_link_can_tell_you_what_planet_it_is_on
	assert_equal(@planet, @link.planet)
  end
  
  def test_start_x_pos
	assert_equal(@storage_facility_a.x_pos, @link.start_x_pos)
  end
  
  def test_start_y_pos
	assert_equal(@storage_facility_a.y_pos, @link.start_y_pos)
  end
  
  def test_end_x_pos
	assert_equal(@storage_facility_b.x_pos, @link.end_x_pos)
  end
  
  def test_end_y_pos
	assert_equal(@storage_facility_b.y_pos, @link.end_y_pos)
  end
  
  # 
  # "Observable" tests
  # 
  
  def test_link_inherits_observable
	assert_true(@link.is_a?(Observable), "Planetary Link did not include Observable.")
  end
  
  # Update method for testing observer.
  def update
	@was_notified_of_change = true
  end
  
  def test_link_notifies_observers_on_level_increase
	@link.upgrade_level=(0)
	
	@link.add_observer(self)
	
	@link.increase_level
	assert_true(@was_notified_of_change, "Planetary Link did not call notify_observers or its state did not change.")
	
	@link.delete_observer(self)
  end
  
  def test_command_center_does_not_notify_observers_if_level_increase_fails
	@link.upgrade_level=(10)
	
	@link.add_observer(self)
	
	@link.increase_level
	assert_false(@was_notified_of_change, "Planetary Link called notify_observers when its state did not change.")
	
	@link.delete_observer(self)
  end
  
  def test_command_center_notifies_observers_on_level_decrease
	# Have to be at an above-zero level to decrease properly.
	@link.upgrade_level=(3)
	
	@link.add_observer(self)
	
	@link.decrease_level
	assert_true(@was_notified_of_change, "Planetary Link did not call notify_observers or its state did not change.")
	
	@link.delete_observer(self)
  end
  
  def test_command_center_does_not_notify_observers_if_level_decrease_fails
	@link.upgrade_level=(0)
	
	@link.add_observer(self)
	
	@link.decrease_level
	assert_false(@was_notified_of_change, "Planetary Link called notify_observers when its state did not change.")
	
	@link.delete_observer(self)
  end
  
  def test_command_center_notifies_observers_on_level_set
	@link.upgrade_level=(0)
	
	@link.add_observer(self)
	
	@link.upgrade_level=(3)
	assert_true(@was_notified_of_change, "Planetary Link did not call notify_observers or its state did not change.")
	
	@link.delete_observer(self)
  end
  
  def test_command_center_does_not_notify_observers_if_level_set_fails
	@link.upgrade_level=(3)
	
	@link.add_observer(self)
	
	@link.upgrade_level=(3)
	assert_false(@was_notified_of_change, "Planetary Link called notify_observers when its state did not change.")
	
	@link.delete_observer(self)
  end
  
  def test_default_num_observers_is_zero
	assert_equal(0, @link.count_observers)
  end
end