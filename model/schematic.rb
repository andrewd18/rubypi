require 'yaml'

require_relative 'product.rb'

# A Schematic defines a series of build requirements for a given product.
class Schematic
  
  attr_reader :output_product_name
  attr_reader :output_quantity
  
  @@schematic_instances = Array.new
  
  def self.all
	return @@schematic_instances
  end
  
  def self.find_by_name(searched_name)
	@@schematic_instances.find {|instance| instance.name == searched_name}
  end
  
  def self.find_by_p_level(searched_p_level)
	@@schematic_instances.select {|instance| instance.p_level == searched_p_level}
  end
  
  def self.delete(schematic_instance)
	raise ArgumentError, "Not a Schematic." unless schematic_instance.is_a?(Schematic)
	
	return @@schematic_instances.delete(schematic_instance)
  end

  def self.save_to_yaml
	abs_filepath = File.expand_path("Schematics.yml", File.dirname(__FILE__))
	yaml_file = File.open(abs_filepath, "w")

	yaml_file.write(YAML::dump(@@schematic_instances))

	yaml_file.close
	
	return true
  end
  
  def self.load_from_yaml
	abs_filepath = File.expand_path("Schematics.yml", File.dirname(__FILE__))
	yaml_file = File.open(abs_filepath, "r")

	@@schematic_instances = YAML::load(yaml_file)

	yaml_file.close
	
	return @@schematic_instances
  end
  
  def initialize(output_product_name = nil, output_quantity = nil, inputs_hash = {})
	@output_product_name = output_product_name
	@output_quantity = output_quantity
	@inputs_hash = inputs_hash
	
	@@schematic_instances << self
	
	return self
  end
  
  def name
	return @output_product_name
  end
  
  def p_level
	product_instance = Product.find_by_name(@output_product_name)
	return product_instance.p_level
  end
  
  def output_product
	return Product.find_by_name(@output_product_name)
  end
  
  def add_input(product_name_to_quantity_hash)
	raise ArgumentError, "Argument is not a Hash." unless product_name_to_quantity_hash.is_a?(Hash)
	
	product_name_to_quantity_hash.each_pair do |key, value|
	  raise ArgumentError, "#{key} is not a String." unless key.is_a?(String)
	  raise ArgumentError, "#{value} is not a Numeric." unless value.is_a?(Numeric)
	  
	  # Error if we already have this input.
	  raise ArgumentError, "#{key} is already an input." if @inputs_hash.has_key?(key)
	end
	
	# Input params are ok. Merge in.
	@inputs_hash.merge!(product_name_to_quantity_hash)
	
	return @inputs_hash
  end
  
  def remove_input(product_name)
	@inputs_hash.delete(product_name)
  end
  
  def inputs
	return @inputs_hash
  end
  
  def outputs
	return {@output_product_name => @output_quantity}
  end
end
