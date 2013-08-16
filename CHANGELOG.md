Scheduled for Next Release
==========================
* You can now add and delete extractor heads from the planet view.
* PG and CPU for planetary links are now calculated.
* Every planet now gets a POCO by default. Whether or not you use it is up to you.
* Extractors can no longer extract P0s that its planet does not have.
* When closing RubyPI, you will be given the opportunity to save your PI Config.
* Added CCP IP notices to the About box.
* Refactored the entire application structure to improve testability.
* Fixed a lot of stupid mistakes that would cause crashes.


Version 0.0.11
==============
* Set a default window size.
* Added a little green ring when hovering over a building to show it's the one you're about to select.
* Added icons to the Edit Building, Delete Building, Add Link, and Delete Link buttons.
* Shrunk the tool buttons so they fit on one screen.
* Added a filter / search mechanism to the add products widget.


Version 0.0.10
==============
* Fixed crash on load when rsvg2 wasn't installed.


Version 0.0.9
=============
* Swapped out the boring planet view table for an interactive widget that works much more like the EVE PI interface.
* You can now add and delete links. They don't give a PG/CPU value yet.
* Likely broke backwards compatibility for old PI Config (.yml) files.


Version 0.0.8
=============
* Added Player Owned Customs Offices (POCOs).
* Removed the "expedited transfer" window in favor of a "transfer products" window, which handles both expedited transfers and planet import/exports.
* Gave Command Centers the ability to launch products to space.
* Added percentage bars to the overview for planet PG and CPU usage.
* Added "Input From:" and "Output To:" combo boxes for factories and extractors.
* Added back-end support for Planetary Links. They don't do anything yet.
* Ensured pop-up windows are modal.
* Set sane default values for some display widgets.


Version 0.0.7
=============
* Fixed a layout bug in the System View and Planet view where widgets wouldn't be sized properly.
* Swapped out text for building icons where appropriate in the System View table header.
* Fixed a layout bug in the Edit Extractor view that caused it to look awful when using a big window. This still requires a little more work.
* Fixed a layout bug in the Edit Factory view that caused it to look awful when using a big window. This still requires a little more work.
* Fixed a layout bug in the Planet View window that caused it to look awful when using a small window.
* Code cleanup.


Version 0.0.6
=============

* Redesigned a good chunk of the UI to act more like EFT/PyFA. Lost some of the bling in the process; it'll be back later.
* You can now add and remove products from buildings.
* You can now expedited transfer products between storage-only buildings.
* You can now tell an extractor how long it should operate for. This should act identically to the EVE slider.
* Added images to each of the edit building pages.
* Completed the view for the Launchpad.
* Removed the artificial limit on number of planets.
* Removed planet alias as it didn't serve much purpose.
* A ton of little bugs were squashed.


Version 0.0.5
=============

* You can now edit a Command Center and upgrade it.
* Added the missing ice and plasma planet images.
* Fixed an issue where loading a PI config from anywhere but the System View would crash RubyPI.
* Fixed a series of missing-reference crashes.
* Fixed an issue where RubyPI ignored your planet type, name, and alias settings.
* Added this Changelog.


Version 0.0.4
=============

* You can now load and save your PI configuration to YML.
* You can now tell an Extractor what it's producing.
* You can no longer add more than one command center to a planet.
* Minor performance enhancements.
* Added more unit tests. Oh god so many unit tests.


Version 0.0.3
=============

* Added base model data for Schematics and Products.
* You can now sort buildings by various stats. Sorting doesn't save.
* You can edit a building.
* You can set a factory's schematic.
* You can add and remove extractor heads. CPU/PG adjusts appropriately.
* Added File and About menus in preparation for loading and saving configurations.
* Added About window.
* Settled on a layout for the Planet View screen that I don't hate.
* Added unit tests to increase rate of features without adding serious bugs.


Version 0.0.2
=============

* Added more planet and building images.
* Reduced # of pop up windows in favor of unified dialogs.


Version 0.0.1
=============

* Contains base model data for planets and buildings.
* System view to see # of planets, and overview of each planet.
* Planet view to see specific buildings on a planet, add/remove buildings.
* Auto-calculates PG, CPU, ISK Cost, etc. of each building.
* One-touch Windows and Linux releases using releasy.
