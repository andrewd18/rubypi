require_relative '../model/product.rb'
require_relative 'add_products_tree_store.rb'

class AddProductsTreeStoreWithFilter < Gtk::TreeModelFilter
  def initialize
	@actual_model = AddProductsTreeStore.new
	
	super(@actual_model)
	
	@query = ""
	
	# Set up row matching function.
	self.set_visible_func do |model, iter|
	  name_match(model, iter)
	end
	
	return self
  end
  
  def name_match(model, iter)
	icon = iter.get_value(0)
	name = iter.get_value(1)
	
	# If we're not filtering anything, show everything.
	if (@query == "")
	  return true
	end
	
	# WORKAROUND
	# If the parent isn't shown, the child won't be shown,
	# even if the child is set to true.
	if (iter.has_child?)
	  return true
	end
	
	# FINALLY we get around to the actual filtering.
	lowercase_name = name.downcase
	if (lowercase_name.include?(@query.downcase))
	  return true
	else
	  return false
	end
  end
  
  def query=(new_query)
	raise ArgumentError unless new_query.is_a?(String)
	
	@query = new_query
	self.refilter
  end
  
  def query
	return @query
  end
  
  def self.destroy
	@actual_model.destroy
	
	super
  end
end