require_relative '../db/connect_to_eve_item_db.rb'
require_relative 'product.rb'

# A Schematic defines a series of build requirements for a given product.
class Schematic < Sequel::Model
  many_to_one :output_product, :class => Product
  many_to_one :primary_input_product, :class => Product
  many_to_one :secondary_input_product, :class => Product
  many_to_one :tertiary_input_product, :class => Product
  
  def name
	return self.output_product.name
  end
end
