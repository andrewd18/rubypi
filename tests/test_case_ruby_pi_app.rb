require "test/unit"

# Define Ocra class to force the RubyPI script to not run.
class Ocra
end

require_relative "../ruby_pi.rb"

class TestCaseRubyPIApp < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@pi_configuration = PIConfiguration.new
	@pi_configuration.add_planet(Planet.new("Lava"))
	
	@ruby_pi = RubyPI.new
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_can_get_main_widget
	the_main_widget = @ruby_pi.main_widget
	
	assert_true(the_main_widget.is_a?(Gtk::Widget))
  end
  
  def test_can_set_main_widget
	system_view_widget = SystemViewWidget.new(@pi_configuration)
	
	@ruby_pi.change_main_widget(system_view_widget)
	
	assert_equal(system_view_widget, @ruby_pi.main_widget)
  end
  
  def test_can_get_menu_bar
	the_menu_bar = @ruby_pi.menu_bar
	
	assert_true(the_menu_bar.is_a?(Gtk::MenuBar))
  end
  
  def test_can_get_pi_configuration
	config = @ruby_pi.pi_configuration
	
	assert_true(config.is_a?(PIConfiguration))
  end
  
  def test_can_set_pi_configuration
	@ruby_pi.pi_configuration = (@pi_configuration)
	
	assert_equal(@pi_configuration, @ruby_pi.pi_configuration)
  end
  
  def test_can_save_and_load_pi_configuration_from_yaml
	# Doesn't work yet.
	pend()
	
	filename = "test_case_ruby_pi_app.yml"
	
	saved_config = @ruby_pi.pi_configuration
	@ruby_pi.save_pi_configuration_to_yaml(filename)
	
	loaded_config = @ruby_pi.load_pi_configuration_from_yaml(filename)
	
	File.delete(filename)
	
	assert_equal(saved_config, loaded_config)
  end
end