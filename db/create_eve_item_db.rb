require_relative 'connect_to_eve_item_db.rb'

# The create_table? method will only create said table if it doesn't already exist.
EVE_ITEM_DB.create_table? :products do
  # Relationship columns.
  primary_key :id
  
  # Data columns.
  String :name
  Integer :p_level
end

EVE_ITEM_DB.create_table? :schematics do
  # Relationship columns.
  primary_key :id
  Integer :output_product_id
  Integer :primary_input_product_id
  Integer :secondary_input_product_id
  Integer :tertiary_input_product_id
  
  # Data columns.
  Integer :output_product_quantity
  Integer :primary_input_product_quantity
  Integer :secondary_input_product_quantity
  Integer :tertiary_input_product_quantity
  Integer :p_level
end
