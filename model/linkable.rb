# Requires the model that includes this to have a Planet.

require 'set'

module Linkable
  def links
	return self.planet.find_links_connected_to(self)
  end
  
  def num_links
	return self.links.count
  end

  def linked_buildings
	unique_linked_buildings = Set.new
	
	self.links.each do |link|
	  # Add whichever building that this link connects to but isn't ourself.
	  if (link.source_building != self)
		unique_linked_buildings.add(link.source_building)
	  else
		unique_linked_buildings.add(link.destination_building)
	  end
	end
	
	return unique_linked_buildings
  end
  
  def num_linked_buildings
	return self.linked_buildings.count
  end
end