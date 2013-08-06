Core Features
=============

* Transfer Products Dialog
  - Add a warning when the user tries to transfer products to a destination that isn't selected yet.
  - Add a warning when the user tries to transfer products from one building to itself.
* A building should not be able to be added if a planet forbids it.
* Add cycle times to all buildings.
* Add a "pipeline view" or a "chain view" or something that shows the product build cycle. Planet scope only.
* Add product unit and volume output per hour per building.
* Warn when there are product overages in the pipeline.
* Warn when there are product underages in the pipeline.
* Hook up to EVE character skills.
* Warn when the settings exceed character skills.


User Interface Improvements
===========================

* When transferring product, allow users to transfer from either side like in EVE, not just left-to-right.
* When adding product, let user type in value (along with slider).
* When removing product, let user type in value (along with slider).
* When transferring product, let user type in value (along with slider).
* Separate one-time build cost from recurring import/export costs.
* Create a View Column Renderer that auto-converts raw ISK values to a human-readable value. Use for all views with isk columns.
* Images
  - Brighten the planet screenshots across the board. Lava, for example, just looks black.
  - Add images for every product. Show where appropriate.
  - Add basic, advanced, and high-tech tags to the factory building images so you can tell them apart.
* Building Drawing Area
  - Add tooltips on hover.
  - Add a max size or something to the drawing window. It's weird when I resize it down and buildings get hidden.
  - Do something visual when deleting links or adding links that shows you're on step two.
* Convert "Transfer Products" widget to an Expedited Transfer widget.
* Create a new, unique Import / Export widget rather than reusing the Transfer Products widget.
  

Code Cleanup
============

* Go through all the views and consolidate stuff down into more generic classes.
* Unify the stats boxes for planets.
* PlanetImage and BuildingImage
  - Either unify or get rid of Observer calls.
  - Allow nil models without crashing.
* Allow every widget I create to accept an optional parent_window.
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

