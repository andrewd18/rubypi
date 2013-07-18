require "test/unit"

require_relative "../model/customs_office.rb"
require_relative "../model/product.rb"

class TestCaseCustomsOffice < Test::Unit::TestCase
  # Run once.
  def self.startup
	@@character = Product.find_or_create("Character", 0)
	@@word = Product.find_or_create("Word", 1)
	@@sentence = Product.find_or_create("Sentence", 2)
	@@paragraph = Product.find_or_create("Paragraph", 3)
	@@essay = Product.find_or_create("Essay", 4)
  end
  
  # Run once after all tests.
  def self.shutdown
	# Cleanup.
	Product.delete(@@character)
	Product.delete(@@word)
	Product.delete(@@sentence)
	Product.delete(@@paragraph)
	Product.delete(@@essay)
  end
  
  # Run before every test.
  def setup
	@building = CustomsOffice.new
  end
  
  # Run after every test.
  def teardown
  end
  
  def test_powergrid_usage_value
	assert_equal(0, @building.powergrid_usage)
  end
  
  def test_cpu_usage_value
	assert_equal(0, @building.cpu_usage)
  end
  
  def test_powergrid_provided_value
	assert_equal(0, @building.powergrid_provided)
  end
  
  def test_cpu_provided_value
	assert_equal(0, @building.cpu_provided)
  end
  
  def test_isk_cost_value
	assert_equal(0.00, @building.isk_cost)
  end
  
  def test_name
	assert_equal("Customs Office", @building.name)
  end
  
  def test_cannot_get_x_position
	assert_raise do
	  @building.x_pos
	end
  end
  
  def test_cannot_get_a_y_position
	assert_raise do
	  @building.y_pos
	end
  end
  
  def test_storage_volume
	assert_equal(35000.0, @building.storage_volume)
  end
  
  def test_default_tax_rate_is_fifteen_percent
	assert_equal(15, @building.tax_rate)
  end
  
  def test_can_set_tax_rate
	assert_equal(15, @building.tax_rate)
	
	@building.tax_rate = 10
	
	assert_equal(10, @building.tax_rate)
  end
  
  def test_cannot_set_tax_rate_below_zero
	assert_equal(15, @building.tax_rate)
	
	assert_raise ArgumentError do
	  @building.tax_rate = (-30)
	end
	
	# Nothing should have changed from default.
	assert_equal(15, @building.tax_rate)
  end
  
  def test_cannot_set_tax_rate_above_one_hundred
	assert_raise ArgumentError do
	  @building.tax_rate = 35000
	end
	
	# Nothing should have changed from default.
	assert_equal(15, @building.tax_rate)
  end
  
  def test_cannot_set_tax_rate_to_non_number
	assert_raise ArgumentError do
	  @building.tax_rate = "faaaail"
	end
	
	# Nothing should have changed from default.
	assert_equal(15, @building.tax_rate)
  end
  
  def test_export_cost_with_tax_scales_with_tax_rate
	# Verify the cost to export a P0.
	#
	# (tax_rate / 100) * product.export_cost_for_quantity
	assert_equal(15, @building.tax_rate)
	base_cost_to_export = @@character.export_cost_for_quantity(1)
	expected_value = (0.15 * base_cost_to_export)
	
	assert_equal(expected_value, @building.export_cost_with_tax("Character", 1))
	
	# Change tax rate and check again.
	@building.tax_rate = 30
	expected_value = (0.30 * base_cost_to_export)
	
	assert_equal(expected_value, @building.export_cost_with_tax("Character", 1))
  end
  
  def test_export_cost_with_tax_scales_with_p_level
	# Verify the cost to export all P-levels.
	#
	# (tax_rate / 100) * product.export_cost_for_quantity
	
	assert_equal(15, @building.tax_rate)
	
	character_base_cost_to_export = @@character.export_cost_for_quantity(1)
	word_base_cost_to_export = @@word.export_cost_for_quantity(1)
	sentence_base_cost_to_export = @@sentence.export_cost_for_quantity(1)
	paragraph_base_cost_to_export = @@paragraph.export_cost_for_quantity(1)
	essay_base_cost_to_export = @@essay.export_cost_for_quantity(1)
	
	expected_value = (0.15 * character_base_cost_to_export)
	assert_equal(expected_value, @building.export_cost_with_tax("Character", 1))
	
	expected_value = (0.15 * word_base_cost_to_export)
	assert_equal(expected_value, @building.export_cost_with_tax("Word", 1))
	
	expected_value = (0.15 * sentence_base_cost_to_export)
	assert_equal(expected_value, @building.export_cost_with_tax("Sentence", 1))
	
	expected_value = (0.15 * paragraph_base_cost_to_export)
	assert_equal(expected_value, @building.export_cost_with_tax("Paragraph", 1))
	
	expected_value = (0.15 * essay_base_cost_to_export)
	assert_equal(expected_value, @building.export_cost_with_tax("Essay", 1))
  end
  
  def test_export_cost_with_tax_scales_with_quantity
	# Verify the cost to export a P0.
	#
	# (tax_rate / 100) * product.export_cost_for_quantity
	assert_equal(15, @building.tax_rate)
	base_cost_to_export = @@character.export_cost_for_quantity(1)
	expected_value = (0.15 * base_cost_to_export)
	
	assert_equal(expected_value, @building.export_cost_with_tax("Character", 1))
	
	# Change quantity and check again.
	base_cost_to_export = @@character.export_cost_for_quantity(50)
	expected_value = (0.15 * base_cost_to_export)
	
	assert_equal(expected_value, @building.export_cost_with_tax("Character", 50))
  end
  
  def test_import_cost_with_tax_scales_with_tax_rate
	# Verify the cost to import a P0.
	#
	# (tax_rate / 100) * product.import_cost_for_quantity
	
	assert_equal(15, @building.tax_rate)
	base_cost_to_import = @@character.import_cost_for_quantity(1)
	expected_value = (0.15 * base_cost_to_import)
	
	assert_equal(expected_value, @building.import_cost_with_tax("Character", 1))
	
	# Change tax rate and check again.
	@building.tax_rate = 30
	expected_value = (0.30 * base_cost_to_import)
	
	assert_equal(expected_value, @building.import_cost_with_tax("Character", 1))
  end
  
  def test_import_cost_with_tax_scales_with_p_level
	# Verify the cost to import all P-levels.
	#
	# (tax_rate / 100) * product.import_cost_for_quantity
	
	assert_equal(15, @building.tax_rate)
	
	character_base_cost_to_import = @@character.import_cost_for_quantity(1)
	word_base_cost_to_import = @@word.import_cost_for_quantity(1)
	sentence_base_cost_to_import = @@sentence.import_cost_for_quantity(1)
	paragraph_base_cost_to_import = @@paragraph.import_cost_for_quantity(1)
	essay_base_cost_to_import = @@essay.import_cost_for_quantity(1)
	
	expected_value = (0.15 * character_base_cost_to_import)
	assert_equal(expected_value, @building.import_cost_with_tax("Character", 1))
	
	expected_value = (0.15 * word_base_cost_to_import)
	assert_equal(expected_value, @building.import_cost_with_tax("Word", 1))
	
	expected_value = (0.15 * sentence_base_cost_to_import)
	assert_equal(expected_value, @building.import_cost_with_tax("Sentence", 1))
	
	expected_value = (0.15 * paragraph_base_cost_to_import)
	assert_equal(expected_value, @building.import_cost_with_tax("Paragraph", 1))
	
	expected_value = (0.15 * essay_base_cost_to_import)
	assert_equal(expected_value, @building.import_cost_with_tax("Essay", 1))
  end
  
  def test_import_cost_with_tax_scales_with_quantity
	# Verify the cost to import a P0.
	#
	# (tax_rate / 100) * product.import_cost_for_quantity
	
	assert_equal(15, @building.tax_rate)
	base_cost_to_import = @@character.import_cost_for_quantity(1)
	expected_value = (0.15 * base_cost_to_import)
	
	assert_equal(expected_value, @building.import_cost_with_tax("Character", 1))
	
	# Change tax rate and check again.
	base_cost_to_import = @@character.import_cost_for_quantity(50)
	expected_value = (0.15 * base_cost_to_import)
	
	assert_equal(expected_value, @building.import_cost_with_tax("Character", 50))
  end
end