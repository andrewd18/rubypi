require "test/unit"

require_relative "../model/pi_configuration.rb"

class TestCasePIConfiguration < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@pi_configuration = PIConfiguration.new
	@was_notified_of_change = false
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_starts_with_no_planets
	assert_true(@pi_configuration.planets.empty?)
  end
  
  def test_can_add_a_planet
	uncolonized_planet = Planet.new("Uncolonized")
	lava_planet = Planet.new("Lava")
	
	@pi_configuration.add_planet(uncolonized_planet)
	
	assert_true(@pi_configuration.planets.include?(uncolonized_planet))
	assert_false(@pi_configuration.planets.include?(lava_planet))
  end
  
  def test_can_remove_a_specific_planet
	uncolonized_planet = Planet.new("Uncolonized")
	lava_planet = Planet.new("Lava")
	
	@pi_configuration.add_planet(uncolonized_planet)
	@pi_configuration.add_planet(lava_planet)
	
	assert_true(@pi_configuration.planets.include?(uncolonized_planet))
	assert_true(@pi_configuration.planets.include?(lava_planet))
	
	@pi_configuration.remove_planet(lava_planet)
	
	assert_true(@pi_configuration.planets.include?(uncolonized_planet))
	assert_false(@pi_configuration.planets.include?(lava_planet))
  end
  
  def test_can_remove_all_planets
	uncolonized_planet = Planet.new("Uncolonized")
	lava_planet = Planet.new("Lava")
	
	@pi_configuration.add_planet(uncolonized_planet)
	@pi_configuration.add_planet(lava_planet)
	
	assert_true(@pi_configuration.planets.include?(uncolonized_planet))
	assert_true(@pi_configuration.planets.include?(lava_planet))
	
	@pi_configuration.remove_all_planets
	
	assert_false(@pi_configuration.planets.include?(uncolonized_planet))
	assert_false(@pi_configuration.planets.include?(lava_planet))
  end
  
  def test_num_planets_scales_with_planets
	uncolonized_planet = Planet.new("Uncolonized")
	
	assert_equal(0, @pi_configuration.num_planets)
	
	@pi_configuration.add_planet(uncolonized_planet)
	assert_equal(1, @pi_configuration.num_planets)
	
	@pi_configuration.add_planet(uncolonized_planet)
	assert_equal(2, @pi_configuration.num_planets)
	
	@pi_configuration.add_planet(uncolonized_planet)
	assert_equal(3, @pi_configuration.num_planets)
	
	@pi_configuration.remove_all_planets
	
	assert_equal(0, @pi_configuration.num_planets)
  end
  
  #
  # Observable tests
  #
  
  def test_pi_config_is_observable
	assert_true(@pi_configuration.is_a?(Observable), "PI Configuration did not include Observable.")
  end
  
  # Update method for testing observer.
  def update
	@was_notified_of_change = true
  end
  
  def test_pi_config_notifies_observers_when_it_adds_a_planet
	uncolonized_planet = Planet.new("Uncolonized")
	
	@pi_configuration.add_observer(self)
	
	@pi_configuration.add_planet(uncolonized_planet)
	
	assert_true(@was_notified_of_change)
	
	@pi_configuration.delete_observer(self)
  end
  
  def test_pi_config_notifies_observers_when_it_removes_a_planet
		uncolonized_planet = Planet.new("Uncolonized")
	lava_planet = Planet.new("Lava")
	
	@pi_configuration.add_planet(uncolonized_planet)
	@pi_configuration.add_planet(lava_planet)
	
	@pi_configuration.add_observer(self)
	
	@pi_configuration.remove_planet(lava_planet)
	
	assert_true(@was_notified_of_change)
	
	@pi_configuration.delete_observer(self)
  end
  
  def test_pi_config_notifies_observers_when_it_removes_all_planets
	uncolonized_planet = Planet.new("Uncolonized")
	@pi_configuration.add_planet(uncolonized_planet)
	
	@pi_configuration.add_observer(self)
	
	@pi_configuration.remove_all_planets
	
	assert_true(@was_notified_of_change)
	
	@pi_configuration.delete_observer(self)
  end
end