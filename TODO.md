Core Features
=============

* Add CCP disclaimer, etc. to About box.
* Building View
  - Add launch-to-space option to Command Centers.
* Transfer Products Dialog
  - Show cost to transfer (if applicable).
  - Make it modal to the parent window.
  - Add a warning when the user tries add products to a destination that isn't selected yet.
  - Show storage percent bars?
  - General code cleanup.
* Prevent user from adding buildings to a planet that the planet doesn't support.
* Add links.
* Add cycle times to all buildings.
* Add product unit and volume output per hour per building.
* Warn when there are product overages in the pipeline.
* Warn when there are product underages in the pipeline.
* Add a "pipeline view" or a "chain view" or something that shows the product build cycle. Planet scope only.
* Hook up to EVE character skills.
* Warn when the settings exceed character skills.


User Interface Improvements
===========================

* When adding product, let user type in value (along with slider).
* When removing product, let user type in value (along with slider).
* When transferring product, let user type in value (along with slider).
* Separate one-time build cost from recurring import/export costs.
* Make ISK cost display go from K to M to make it more human readable.
* Images
  - Brighten the planet screenshots across the board. Lava, for example, just looks black.
  - Add images for every product. Show where appropriate.
  - Add images of extractor heads in the EditExtractorWindow.


Code Cleanup
============

* Go through all the views and consolidate stuff down into more generic classes.
* Unify the stats boxes for planets.
* Unit Tests
  - Figure out how to test event hooks in unit tests so I can fully test views.
  - Keep adding more!
* Do my own serialization of @pi_configuration that doesn't rely on a straight YAML dump.
* Refactor out Observer to make serialization easier and the data more database-like?


Packaging & Release
===================

* Windows
  - Research why the EXE is so huge.
* Mac
  - Lure in some Mac beta testers. Cookies? Apple fritters?

