require "test/unit"

require_relative "../view/gtk_helpers/simple_combo_box.rb"

class TestCaseSimpleComboBox < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@simple_combo_box = SimpleComboBox.new
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_inherits_off_gtk_combo_box
	assert_true(@simple_combo_box.is_a?(Gtk::ComboBox))
  end
  
  def test_has_a_valid_gtk_list_store_model
	assert_true(@simple_combo_box.model.is_a?(Gtk::ListStore))
  end
  
  def test_has_a_valid_gtk_cell_renderer
	assert_true(@simple_combo_box.cell_renderer.is_a?(Gtk::CellRenderer))
  end
  
  def test_starts_with_no_combo_box_items
	assert_equal(Array.new, @simple_combo_box.items)
  end
  
  def test_can_start_with_given_list_of_combo_box_items
	nintendo_consoles = ["NES", "SNES", "N64", "Gamecube", "Wii", "WiiU"]
	
	@simple_combo_box = SimpleComboBox.new(nintendo_consoles)
	
	assert_equal(nintendo_consoles, @simple_combo_box.items)
  end
  
  def test_can_add_a_text_item_to_combo_box
	gameboy = ["Gameboy"]
	
	@simple_combo_box.add_item("Gameboy")
	
	assert_equal(gameboy, @simple_combo_box.items)
  end
  
  def test_errors_if_non_text_item_is_added_to_combo_box
	gameboy = Object.new
	
	assert_raise do
	  @simple_combo_box.add_item(gameboy)
	end
	
	assert_equal(Array.new, @simple_combo_box.items)
  end
  
  def test_can_remove_a_specific_item_from_combo_box
	nintendo_consoles = ["NES", "SNES", "N64", "Gamecube", "Wii", "WiiU"]
	nintendo_consoles_minus_wiiu = ["NES", "SNES", "N64", "Gamecube", "Wii"]
	
	@simple_combo_box = SimpleComboBox.new(nintendo_consoles)
	
	@simple_combo_box.remove_item("WiiU")
	
	assert_equal(nintendo_consoles_minus_wiiu, @simple_combo_box.items)
  end
  
  def test_when_removing_item_error_occurs_if_item_isnt_in_list
	nintendo_consoles = ["NES", "SNES", "N64", "Gamecube", "Wii", "WiiU"]
	
	@simple_combo_box = SimpleComboBox.new(nintendo_consoles)
	
	assert_raise do
	  @simple_combo_box.remove_item("PS3")
	end
	
	assert_equal(nintendo_consoles, @simple_combo_box.items)
  end
  
  def test_can_remove_all_items_from_combo_box
	nintendo_consoles = ["NES", "SNES", "N64", "Gamecube", "Wii", "WiiU"]
	
	@simple_combo_box = SimpleComboBox.new(nintendo_consoles)
	
	assert_equal(nintendo_consoles, @simple_combo_box.items)
	
	@simple_combo_box.remove_all_items
	
	assert_equal(Array.new, @simple_combo_box.items)
  end
  
  def test_can_set_all_list_items
	assert_equal(Array.new, @simple_combo_box.items)
	
	nintendo_consoles = ["NES", "SNES", "N64", "Gamecube", "Wii", "WiiU"]
	
	@simple_combo_box.items=(nintendo_consoles)
	
	assert_equal(nintendo_consoles, @simple_combo_box.items)
  end
  
  def test_when_setting_all_list_items_errors_if_item_is_not_string
	assert_equal(Array.new, @simple_combo_box.items)
	
	blank_object = Object.new
	
	nintendo_consoles_with_non_string_object = ["NES", "SNES", "N64", "Gamecube", blank_object, "Wii", "WiiU"]
	
	assert_raise do
	  @simple_combo_box.items=(nintendo_consoles_with_non_string_object)
	end
	
	assert_equal(Array.new, @simple_combo_box.items)
  end
  
  def test_when_setting_all_list_items_the_selected_item_is_forced_to_nil
	assert_equal(Array.new, @simple_combo_box.items)
	
	nintendo_consoles = ["NES", "SNES", "N64", "Gamecube", "Wii", "WiiU"]
	
	@simple_combo_box.items=(nintendo_consoles)
	
	assert_equal(nintendo_consoles, @simple_combo_box.items)
	assert_equal(nil, @simple_combo_box.selected_item)
	
	# Set to NES
	@simple_combo_box.selected_item="NES"
	
	# Re-set items.
	@simple_combo_box.items=(nintendo_consoles)
	
	# Should be reset to nil.
	assert_equal(nil, @simple_combo_box.selected_item)
  end
  
  def test_can_set_currently_selected_item
	nintendo_consoles = ["NES", "SNES", "N64", "Gamecube", "Wii", "WiiU"]
	
	@simple_combo_box.items=(nintendo_consoles)
	
	assert_equal(nil, @simple_combo_box.selected_item)
	
	@simple_combo_box.selected_item=("Gamecube")
	
	assert_equal("Gamecube", @simple_combo_box.selected_item)
  end
  
  def test_can_set_currently_selected_item_to_nil
	nintendo_consoles = ["NES", "SNES", "N64", "Gamecube", "Wii", "WiiU"]
	
	@simple_combo_box.items=(nintendo_consoles)
	
	assert_equal(nil, @simple_combo_box.selected_item)
	
	@simple_combo_box.selected_item=("Gamecube")
	
	assert_equal("Gamecube", @simple_combo_box.selected_item)
	
	@simple_combo_box.selected_item=(nil)
	
	assert_equal(nil, @simple_combo_box.selected_item)
  end
  
  def test_when_setting_item_error_occurs_if_item_isnt_in_list
	nintendo_consoles = ["NES", "SNES", "N64", "Gamecube", "Wii", "WiiU"]
	
	@simple_combo_box.items=(nintendo_consoles)
	
	assert_equal(nil, @simple_combo_box.selected_item)
	
	assert_raise do
	  @simple_combo_box.selected_item=("PS3")
	end
	
	assert_equal(nil, @simple_combo_box.selected_item)
  end
  
  def test_can_ask_if_items_contain_a_given_string
	nintendo_consoles = ["NES", "SNES", "N64", "Gamecube", "Wii", "WiiU"]
	
	@simple_combo_box.items=(nintendo_consoles)
	
	assert_true(@simple_combo_box.contains_item?("NES"))
	assert_false(@simple_combo_box.contains_item?("PS3"))
  end
end