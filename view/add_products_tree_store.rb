require_relative '../model/product.rb'

class AddProductsTreeStore < Gtk::TreeStore
  def initialize
	super(Gdk::Pixbuf,	# Icon
	      String        # Name
	      )
	
	
	# Populate the tree store.
	p_zero_header_row = self.append(nil)
	p_zero_header_row.set_value(1, "P0 Products")
	
	p_one_header_row = self.append(nil)
	p_one_header_row.set_value(1, "P1 Products")
	
	p_two_header_row = self.append(nil)
	p_two_header_row.set_value(1, "P2 Products")
	
	p_three_header_row = self.append(nil)
	p_three_header_row.set_value(1, "P3 Products")
	
	p_four_header_row = self.append(nil)
	p_four_header_row.set_value(1, "P4 Products")

	all_products = Product.all
	all_products.each do |product|
	  case (product.p_level)
	  when (0)
		new_product_row = self.append(p_zero_header_row)
	  when (1)
		new_product_row = self.append(p_one_header_row)
	  when (2)
		new_product_row = self.append(p_two_header_row)
	  when (3)
		new_product_row = self.append(p_three_header_row)
	  when (4)
		new_product_row = self.append(p_four_header_row)
	  end
	  
	  # new_product_row.set_value(0)  TODO: Product Icon
	  new_product_row.set_value(1, product.name)
	end
	
	return self
  end
end