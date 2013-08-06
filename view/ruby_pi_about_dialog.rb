require 'gtk3'

class RubyPIAboutDialog < Gtk::AboutDialog
  def initialize
	super
	
	self.name = "About RubyPI"
	self.program_name = "RubyPI"
	self.version = RubyPI::VERSION
	
	copyright = "Copyright (C) 2013, Andrew Dorney <andrewd18@gmail.com>"
	copyright += "\n\n"
	copyright += "EVE Online is a registered trademark of CCP hf. All rights are reserved worldwide."
	self.copyright = copyright
	
	
	# Full CCP Copyright notices.
	licenses = "EVE Online and the EVE logo are the registered trademarks of CCP hf. All rights are reserved worldwide."
	licenses += "\n\n"
	licenses += "EVE Online, the EVE logo, EVE and all associated logos and designs are the intellectual property of CCP hf."
	licenses += "\n\n"
	licenses += "All artwork, screenshots, characters, vehicles, storylines, world facts or other recognizable features of "
	licenses += "the intellectual property relating to these trademarks are likewise the intellectual property of CCP hf."
	
	# Couple of paragraphs.
	licenses += "\n\n\n\n"
	
	# GPL License.
	licenses += "This program is free software: you can redistribute it and/or modify "
	licenses += "it under the terms of the GNU General Public License as published by "
	licenses += "the Free Software Foundation, either version 3 of the License, or "
	licenses += "(at your option) any later version."
	licenses += "\n\n"
	licenses += "This program is distributed in the hope that it will be useful, "
	licenses += "but WITHOUT ANY WARRANTY; without even the implied warranty of "
	licenses += "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the "
	licenses += "GNU General Public License for more details."
	licenses += "\n\n"
	licenses += "You should have received a copy of the GNU General Public License "
	licenses += "along with this program.  If not, see <http://www.gnu.org/licenses/>."

	self.license = licenses
	self.wrap_license = true

	self.website = "http://github.com/andrewd18/rubypi"
	
	return self
  end
end