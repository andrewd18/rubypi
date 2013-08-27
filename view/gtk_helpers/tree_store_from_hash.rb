require 'gtk3'

class TreeStoreFromHash < Gtk::TreeStore
  def initialize(hash)
	super(String,       # Key
	      String        # Value
	      )
	
	self.hash=(hash)
	
	return self
  end
  
  def hash=(new_hash)
	raise ArgumentError unless (new_hash.is_a?(Hash))
	
	# Clear self.
	self.clear
	
	new_hash.each_pair do |key, value|
	  create_row_for_pair(key, value, nil)
	end
  end
  
  private
  
  def create_row_for_pair(key, value, parent)
	new_row = self.append(parent)
	new_row.set_value(0, key.to_s)
	new_row.set_value(1, value.to_s)
	
	if value.respond_to?(:each_pair)
	  value.each_pair do |sub_key, sub_value|
		create_row_for_pair(sub_key, sub_value, new_row)
	  end
	end
  end
end