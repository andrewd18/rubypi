require_relative '../db/connect_to_eve_item_db.rb'

class Product < Sequel::Model
  # id
  # name
  # p_level
  one_to_many :schematics
end