require 'gtk3'

require_relative 'cairo_building_image.rb'
require_relative 'cairo_link_image.rb'

# CREATE
# On-click, adds selected building type to model at location.
# On-hover, shows selected building type under cursor, faded out.
# On-hover, shows selected building type under cursor, red-shaded if coordinates taken.

# READ
# Draws each building
# Draws each link

# UPDATE / EDIT
# On model change, update all.

# DESTROY
# On <something> remove building and connected links from the model.

class BuildingDrawingArea < Gtk::DrawingArea
  
  BUILDING_ICON_SIZE = 64
  
  # N pixels = 1 "kilometer".
  PIXEL_TO_KM_SCALE = 1.28
  
  ON_CLICK_ACTIONS = ["add_building",
                      "add_extractor_head",
					  "move_building",
					  "edit_building",
					  "delete_building",
                      "add_link",
					  "delete_link"]
  
  attr_accessor :planet_model
  
  def initialize(controller)
	# Set up GTK stuffs.
	super()
	
	@controller = controller
	
	# move_building state variables
	@add_building_class = nil
	
	# add_link state variables
	@add_link_first_building = nil
	
	# add_extractor_head state variables
	@add_extractor_head_parent_extractor = nil
	
	@cursor_x_pos = 0.0
	@cursor_y_pos = 0.0
	
	# Set up auto-refresh of drawing area.
	self.signal_connect('draw') do |widget, cairo_context|
	  self.draw_all(widget, cairo_context)
	end
	
	self.add_events(Gdk::Event::Mask::POINTER_MOTION_MASK)
	self.signal_connect('motion-notify-event') do |widget, event|
	  on_motion_notify(widget, event)
	end
	
	self.add_events(Gdk::Event::Mask::LEAVE_NOTIFY_MASK)
	self.signal_connect('leave-notify-event') do |widget, event|
	  on_leave_notify(widget, event)
	end
	
	self.add_events(Gdk::Event::Mask::BUTTON_PRESS_MASK)
	self.signal_connect('button-press-event') do |widget, event|
	  on_click(widget, event)
	end
	
	self.add_events(Gdk::Event::Mask::BUTTON_RELEASE_MASK)
	self.signal_connect('button-release-event') do |widget, event|
	  on_release(widget, event)
	end
	
	# Set size request(width in px, height in px)
	# Request 8 buildings wide x 5 buildings tall.
	self.set_size_request((BUILDING_ICON_SIZE * 8), (BUILDING_ICON_SIZE * 5))
	
	return self
  end
  
  def set_on_click_action(string)
	raise ArgumentError unless (ON_CLICK_ACTIONS.include?(string))
	
	@on_click_action = string
	
	# TODO:
	# When the action is changed from one state to another, clear all values from the old state.
	# Namely, @add_building_class to nil if we are no longer adding a building.
  end
  
  def set_add_building_type(building_class)
	raise unless (building_class.is_a?(Class))
	
	@add_building_class = building_class
  end
  
  def draw_all(widget, cairo_context)
	if (self.destroyed?)
	  return
	end
	
	if (@planet_model == nil)
	  return
	end
	
	# Draw from back to front.
	# BACKGROUND COLOR
	cairo_context.save do
	  red   = (255.0 / 255)
	  green = (255.0 / 255)
	  blue  = (255.0 / 255)
	  alpha = (255.0 / 255)
	  
	  cairo_context.set_source_rgba(red, green, blue, alpha)
	  cairo_context.paint
	end
	
	# Extractor Heads
	@planet_model.extractors.each do |parent_extractor|
	  parent_extractor.extractor_heads.each do |head|
		cairo_context.save do

		  # Aqua color for extractor "links".
		  red   = (29.0 / 255)
		  green = (141.0 / 255)
		  blue  = (143.0 / 255)
		  alpha = (255.0 / 255)
		  
		  cairo_context.set_source_rgba(red, green, blue, alpha)
		  cairo_context.set_line_width(2.0)
		  cairo_context.set_dash(5.0, 5.0)
		  
		  # Move to the coordinates for the parent extractor.
		  cairo_context.move_to(parent_extractor.x_pos, parent_extractor.y_pos)
		  
		  # Draw a line between the parent extractor and the head.
		  cairo_context.line_to(head.x_pos, head.y_pos)
		  
		  cairo_context.stroke
		end
		
		cairo_context.save do  
		  # Create an extractor head building image.
		  building_image = CairoBuildingImage.new(head, BUILDING_ICON_SIZE, BUILDING_ICON_SIZE)
		  
		  # Set its invalid position or highlighted status accordingly.
		  building_image.invalid_position = will_extractor_head_overlap?(head)
		  
		  # Only highlight if we're not adding a building.
		  if (@on_click_action != "add_building")
			building_image.highlighted = (head == self.building_under_cursor)
		  end
		  
		  building_image.draw(cairo_context)
		end
	  end
	end
	
	# LINKS
	@planet_model.links.each do |link|
	  image = CairoLinkImage.new(link)
	  image.draw(cairo_context)
	end
	
	# BUILDINGS
	@planet_model.buildings.each do |building|
	  image = CairoBuildingImage.new(building, BUILDING_ICON_SIZE, BUILDING_ICON_SIZE)
	  
	  # Set its invalid position or highlighted status accordingly.
	  image.invalid_position = will_building_position_overlap?(building)
	  
	  # Only highlight if we're not adding a building.
	  if (@on_click_action != "add_building")
		image.highlighted = (building == self.building_under_cursor)
	  end
	  
	  image.draw(cairo_context)
	end
	
	# CURSOR
	# Change what and how we draw based on the selected action.
	case (@on_click_action)
	  
	when "add_building"
	  # Draw within a cairo_context transation.
	  cairo_context.save do
		
		# If the cursor position is within the window
		if (((@cursor_x_pos > 0.0) && (@cursor_x_pos < self.allocated_width)) &&
			((@cursor_y_pos > 0.0) && (@cursor_y_pos < self.allocated_height)))
		  
		  # Create a building image.
		  fake_building = @add_building_class.new(@cursor_x_pos, @cursor_y_pos)
		  image = CairoBuildingImage.new(fake_building, BUILDING_ICON_SIZE, BUILDING_ICON_SIZE)
		  
		  # Set the image overlap value appropriately.
		  image.invalid_position = self.will_building_position_overlap?(fake_building)
		  
		  # Draw the building image.
		  image.draw(cairo_context)
		end
	  end
	  
	
	when "add_extractor_head"
	  # If the user has selected an extractor,
	  # draw a line between the first building and the cursor position.
	  # Also draw the extractor head icon underneath the cursor position.
	  if (@add_extractor_head_parent_extractor != nil)
		# If the cursor position is within the window
		if (((@cursor_x_pos > 0.0) && (@cursor_x_pos < self.allocated_width)) &&
			((@cursor_y_pos > 0.0) && (@cursor_y_pos < self.allocated_height)))
		  
		  # Do all the painting in a transaction.
		  cairo_context.save do

			# Aqua color for extractors.
			red   = (29.0 / 255)
			green = (141.0 / 255)
			blue  = (143.0 / 255)
			alpha = (255.0 / 255)
			
			cairo_context.set_source_rgba(red, green, blue, alpha)
			cairo_context.set_line_width(2.0)
			cairo_context.set_dash(5.0, 5.0)
			
			# Move to the coordinates for this slot.
			cairo_context.move_to(@add_extractor_head_parent_extractor.x_pos, @add_extractor_head_parent_extractor.y_pos)
			
			# Draw a line to the connected slot.
			cairo_context.line_to(@cursor_x_pos, @cursor_y_pos)
			
			cairo_context.stroke
		  end
		  
		  cairo_context.save do
			# Create an extractor head building image.
			extractor_head_class = ExtractorHead
			fake_building = extractor_head_class.new(nil, @cursor_x_pos, @cursor_y_pos)
			image = CairoBuildingImage.new(fake_building, BUILDING_ICON_SIZE, BUILDING_ICON_SIZE)
			
			# Set the image overlap value appropriately.
			image.invalid_position = self.will_extractor_head_overlap?(fake_building)
			
			# Draw the building image.
			image.draw(cairo_context)
		  end
		end
	  end
	
	  
	#when "move_building"
	  # puts "move_building"
	
	#when "edit_building"
	  # puts "edit_building"
	  
	#when "delete_building"
	  # puts "delete_building"
	  
	when "add_link"
	  # If the first building has been set to a real building,
	  # draw a line between the first building and the cursor position.
	  if (@add_link_first_building != nil)
		# Do all the painting in a transaction.
		cairo_context.save do

		  red   = (208.0 / 255)
		  green = (149.0 / 255)
		  blue  = (71.0 / 255)
		  alpha = (255.0 / 255)
		  
		  cairo_context.set_source_rgba(red, green, blue, alpha)
		  cairo_context.set_line_width(2.0)
		  cairo_context.set_dash(5.0, 5.0)
		  
		  # Move to the coordinates for this slot.
		  cairo_context.move_to(@add_link_first_building.x_pos, @add_link_first_building.y_pos)
		  
		  # Draw a line to the connected slot.
		  cairo_context.line_to(@cursor_x_pos, @cursor_y_pos)
		  
		  cairo_context.stroke
		end
	  end
	  
	#when "delete_link"
	  # puts "delete_link"
	
	else
	  # puts "BuildingDrawingArea.on_click: unknown action #{@on_click_action}"
	end
  end
  
  def building_under_cursor
	@planet_model.buildings.each do |existing_building|
	  
	  # Is a point within a circle?
	  # 
	  # (x - center_x)^2 + (y - center_y)^2 < radius^2
	  
	  x_pos_distance_squared = ((@cursor_x_pos - existing_building.x_pos)**2)
	  y_pos_distance_squared = ((@cursor_y_pos - existing_building.y_pos)**2)
	  radius_squared = ((BUILDING_ICON_SIZE / 2)**2)
	  
	  if ((x_pos_distance_squared + y_pos_distance_squared) < radius_squared)
		return existing_building
	  end
	end
	
	@planet_model.extractors.each do |parent_extractor|
	  parent_extractor.extractor_heads.each do |head|
		# Is a point within a circle?
		# 
		# (x - center_x)^2 + (y - center_y)^2 < radius^2
		
		x_pos_distance_squared = ((@cursor_x_pos - head.x_pos)**2)
		y_pos_distance_squared = ((@cursor_y_pos - head.y_pos)**2)
		radius_squared = ((BUILDING_ICON_SIZE / 2)**2)
		
		if ((x_pos_distance_squared + y_pos_distance_squared) < radius_squared)
		  return head
		end
	  end
	end  
	
	# Didn't find anything.
	return nil
  end
  
  def will_building_position_overlap?(building_to_check)
	@planet_model.buildings.each do |existing_building|
	  # Skip self.
	  next unless (building_to_check != existing_building)
	  
	  # Is a point within a circle?
	  # 
	  # (x - center_x)^2 + (y - center_y)^2 < radius^2
	  
	  x_pos_distance_squared = ((building_to_check.x_pos - existing_building.x_pos)**2)
	  y_pos_distance_squared = ((building_to_check.y_pos - existing_building.y_pos)**2)
	  diameter_squared = (BUILDING_ICON_SIZE**2)
	  
	  # I use diameter squared because I'm calculating for two circles, not a point within one.
	  
	  if ((x_pos_distance_squared + y_pos_distance_squared) < diameter_squared)
		return true
	  end
	end
	
	return false
  end
  
  def will_extractor_head_overlap?(extractor_head_to_check)
	@planet_model.extractors.each do |parent_extractor|
	  parent_extractor.extractor_heads.each do |head|
		# Skip self.
		next unless (extractor_head_to_check != head)
		
		# Is a point within a circle?
		# 
		# (x - center_x)^2 + (y - center_y)^2 < radius^2
		
		x_pos_distance_squared = ((extractor_head_to_check.x_pos - head.x_pos)**2)
		y_pos_distance_squared = ((extractor_head_to_check.y_pos - head.y_pos)**2)
		diameter_squared = (BUILDING_ICON_SIZE**2)
		
		# I use diameter squared because I'm calculating for two circles, not a point within one.
		
		if ((x_pos_distance_squared + y_pos_distance_squared) < diameter_squared)
		  return true
		end
	  end
	end
	
	return false
  end
  
  def calculate_link_length(link)
	bldg_a = link.source_building
	bldg_b = link.destination_building
	
	x_pos_distance_squared = ((bldg_a.x_pos - bldg_b.x_pos)**2)
	y_pos_distance_squared = ((bldg_a.y_pos - bldg_b.y_pos)**2)
	
	distance_between_centers_in_px = Math.sqrt(x_pos_distance_squared + y_pos_distance_squared)
	distance_between_centers_in_km = (distance_between_centers_in_px / PIXEL_TO_KM_SCALE)
	
	link.length = distance_between_centers_in_km
	# puts "calculate_link_length: #{link.length}"
  end
  
  private
  
  # Called when the pointer moves and is inside the drawing area.
  def on_motion_notify(widget, event)
	# No matter what, update the cursor position.
	@cursor_x_pos = event.x
	@cursor_y_pos = event.y
	
	# If the move action is selected...
	if (@on_click_action == "move_building")
	  # ... and the user has previously clicked and held a specific building...
	  if (@move_building_selected_building != nil)
		
		# ... then determine where the pointer is in relation to the window
		# and draw the building in the right spot.
		if @cursor_x_pos < 0.0
		  @move_building_selected_building.x_pos = 0.0
		elsif @cursor_x_pos > self.allocated_width
		  @move_building_selected_building.x_pos = self.allocated_width
		else
		  @move_building_selected_building.x_pos = @cursor_x_pos
		end
		
		if @cursor_y_pos < 0.0
		  @move_building_selected_building.y_pos = 0.0
		elsif @cursor_y_pos > self.allocated_height
		  @move_building_selected_building.y_pos = self.allocated_height
		else
		  @move_building_selected_building.y_pos = @cursor_y_pos
		end
		
		# Recalculate the lengths of each link associated with this building.
		if @move_building_selected_building.is_a?(Linkable)
		  @move_building_selected_building.links.each do |link|
			link.length = self.calculate_link_length(link)
		  end
		end
	  end
	end
	
	# Redraw the whole screen.
	if (self.destroyed? == false)
	  self.queue_draw
	end
  end
  
  # Called once when the pointer leaves the drawing area.
  def on_leave_notify(widget, event)
	# Force the cursor x/y position to 0, returning us to the default state.
	# Setting it to 0.0 ensures that if the drawing window is resized larger and the cursor position
	# is returned to within the window size, we don't draw a phantom building beneath the old cursor coords.
	@cursor_x_pos = 0.0
	@cursor_y_pos = 0.0
	
	# Force a redraw of the widget.
	if (self.destroyed? == false)
	  self.queue_draw
	end
  end
  
  def add_building_to_model
	# Create a new building of the selected class at the cursor position.
	new_building = @add_building_class.new(@cursor_x_pos, @cursor_y_pos)
	
	# Check to see if it would overlap.
	if (self.will_building_position_overlap?(new_building) == true)
	  # TODO - Tell the user what happened nicely.
	  # For now, spit the error out to the command line.
	  puts "Cannot add a building where it would overlap."
	  return
	end
	
	# If it didn't overlap, add it.
	@controller.add_building(new_building)
  end
  
  def delete_building_from_model
	building_to_remove = self.building_under_cursor
	
	if (building_to_remove == nil)
	  return
	else
	  @controller.delete_building(building_to_remove)
	end
  end
  
  def add_link_to_model
	source_building = @add_link_first_building
	destination_building = self.building_under_cursor
	
	# If either one of these "buildings" is nil, abort.
	if (source_building == nil) or (destination_building == nil)
	  return
	else
	  new_link = @controller.add_link(source_building, destination_building)
	  link_length = self.calculate_link_length(new_link)
	  @controller.set_link_length(source_building, destination_building, link_length)
	end
  end
  
  def delete_link_from_model
	source_building = @delete_link_first_building
	destination_building = self.building_under_cursor
	
	# If either one of these "buildings" is nil, abort.
	if (source_building == nil) or (destination_building == nil)
	  return
	else
	  # Otherwise, delete the link.
	  @controller.delete_link(source_building, destination_building)
	end
  end
  
  def add_extractor_head_to_model
	begin
	  @controller.add_extractor_head(@add_extractor_head_parent_extractor, @cursor_x_pos, @cursor_y_pos)
	rescue ArgumentError => error
	  # TODO - Tell the user what happened nicely.
	  # For now, spit it out to the command line.
	  puts error
	end
  end
  
  # Called when the user clicks within the drawing area.
  def on_click(widget, event)
	# No matter what, update the cursor position.
	@cursor_x_pos = event.x
	@cursor_y_pos = event.y
	
	# Then, determine what else to do based on the selected action.
	case (@on_click_action)
	  
	when "add_building"
	  add_building_to_model
	  
	when "add_extractor_head"
	  # If the add_extractor_head_parent_extractor variable is nil, that means the user either
	  # didn't click on an extractor the first time, or has yet to click on an extractor.
	  if (@add_extractor_head_parent_extractor == nil)
		# self.building_under_cursor will return nil if nothing is found,
		# ensuring that this gets called again properly if the user clicks on blank space.
		building_under_cursor = self.building_under_cursor
		
		if (building_under_cursor.is_a?(Extractor))
		  @add_extractor_head_parent_extractor = building_under_cursor
		else
		  @add_extractor_head_parent_extractor = nil
		end
	  else
		# This must be the second click.
		add_extractor_head_to_model
		
		# Re-set the link state.
		@add_extractor_head_parent_extractor = nil
	  end
	  
	  
	when "move_building"
	  # User wants to grab the building under the cursor. Set the selection.
	  @move_building_selected_building = self.building_under_cursor
	
	when "edit_building"
	  selected_building = self.building_under_cursor
	  
	  # If the building exists and is not an extractor head...
	  if ((selected_building != nil) &&
		  (selected_building.is_a?(ExtractorHead) == false))
		
		@controller.edit_selected_building(selected_building)
	  end
	  
	  
	when "delete_building"
	  delete_building_from_model
	  
	when "add_link"
	  # If the add_link_first_building variable is nil, that means the user either
	  # didn't click on a building the first time, or has yet to click on a building.
	  if (@add_link_first_building == nil)
		# self.building_under_cursor will return nil if nothing is found,
		# ensuring that this gets called again properly if the user clicks on blank space
		@add_link_first_building = self.building_under_cursor
	  else
		# This must be the second click.
		add_link_to_model
		
		# Re-set the link state.
		@add_link_first_building = nil
	  end
	  
	when "delete_link"
	  # If the delete_link_first_building variable is nil, that means the user either
	  # didn't click on a building the first time, or has yet to click on a building.
	  if (@delete_link_first_building == nil)
		# self.building_under_cursor will return nil if nothing is found,
		# ensuring that this gets called again properly if the user clicks on blank space
		@delete_link_first_building = self.building_under_cursor
	  else
		delete_link_from_model
		
		# Reset the delete-link state.
		@delete_link_first_building = nil
	  end
	
	else
	  raise RuntimeError, "BuildingDrawingArea.on_click: unknown action #{@on_click_action}"
	end
	
	# Finally, force a redraw of the widget.
	if (self.destroyed? == false)
	  self.queue_draw
	end
  end
  
  # Called when the user releases a button within the drawing area.
  def on_release(widget, event)
	# No matter what, update the cursor position.
	@cursor_x_pos = event.x
	@cursor_y_pos = event.y
	
	# Then, determine what else to do based on the selected action.
	case (@on_click_action)
	  
	when "add_building"
	  # Mouse release with add_building does nothing, as we only add a building on click.
	  
	when "add_extractor_head"
	  # Mouse release with add_extractor_head does nothing, as we only add an extractor on click.
	  
	when "move_building"
	  # User wants to let go of the building. Clear the selection. 
	  @move_building_selected_building = nil
	
	when "edit_building"
	  # TODO
	  puts "edit_building_release"
	  
	when "delete_building"
	  # TODO
	  puts "delete_building_release"
	  
	when "add_link"
	  # TODO
	  puts "add_link_release"
	  
	when "delete_link"
	  # TODO
	  puts "delete_link_release"
	
	else
	  raise RuntimeError, "BuildingDrawingArea.on_click: unknown action #{@on_click_action}"
	end
	
	# Finally, force a redraw of the widget.
	if (self.destroyed? == false)
	  self.queue_draw
	end
  end
end