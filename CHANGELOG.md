Staged For Next Release
=======================
* Fixed a layout bug in the System View and Planet view where widgets wouldn't be sized properly.
* Swapped out text for building icons where appropriate in the System View table header.
* Fixed a layout bug in the Edit Extractor view that caused it to look awful when using a big window. This still requires a little more work.
* Fixed a layout bug in the Edit Factory view that caused it to look awful when using a big window. This still requires a little more work.
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
