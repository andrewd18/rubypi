require_relative 'add_planets_tree_view.rb'

class AddPlanetsWidget < Gtk::ScrolledWindow
  def initialize(pi_configuration_model)
	super(nil)
	
	@pi_configuration_model = pi_configuration_model
	
	# Never have a horizontal scrollbar.
	# Never have a vertical scrollbar.
	self.set_policy(Gtk::PolicyType::NEVER, Gtk::PolicyType::NEVER)
	
	@add_planets_tree_view = AddPlanetsTreeView.new(@pi_configuration_model)
	self.add(@add_planets_tree_view)
	
	return self
  end

  def destroy
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end