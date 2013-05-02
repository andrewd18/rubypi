require 'gtk3'

class RubyPIAboutDialog < Gtk::AboutDialog
  def initialize
	super
	
	self.name = "About RubyPI"
	self.program_name = "RubyPI"
	self.version = "0.0.5"
	self.copyright = "Copyright (C) 2013, Andrew Dorney <andrewd18@gmail.com>"

	gplv3 = "This program is free software: you can redistribute it and/or modify "
	gplv3 += "it under the terms of the GNU General Public License as published by "
	gplv3 += "the Free Software Foundation, either version 3 of the License, or "
	gplv3 += "(at your option) any later version."
	gplv3 += "\n\n"
	gplv3 += "This program is distributed in the hope that it will be useful, "
	gplv3 += "but WITHOUT ANY WARRANTY; without even the implied warranty of "
	gplv3 += "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the "
	gplv3 += "GNU General Public License for more details."
	gplv3 += "\n\n"
	gplv3 += "You should have received a copy of the GNU General Public License "
	gplv3 += "along with this program.  If not, see <http://www.gnu.org/licenses/>."

	self.license = gplv3
	self.wrap_license = true

	self.website = "http://github.com/andrewd18/rubypi"
	
	return self
  end
end