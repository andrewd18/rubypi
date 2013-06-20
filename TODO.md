Core Features
=============

* Add CCP disclaimer, etc. to About box.
* Building View
  - Add "set destination" button for extractors/factories.
  - Add POCO import/export to Launchpads.
  - Add launch-to-space option to Command Centers.
* Prevent user from adding buildings to a planet that the planet doesn't support.
* Add links.
  - Auto-populate?
* Add cycle times to all buildings.
* Add product unit and volume output per hour per building.
* Warn when there are product overages in the pipeline.
* Warn when there are product underages in the pipeline.
* Hook up to EVE character skills.
* Warn when the settings exceed character skills.


User Interface Improvements
===========================

* Make the factory and extractor views act more like the newer Launchpad and Command Center views.
* Images
  - Brighten the planet screenshots across the board. Lava, for example, just looks black.
* User should be able to see images of extractor heads in the edit extractor window.
* Add images for every product. Show them where appropriate.
* Warn when buildings use more CPU than is provided.
* Warn when buildings use more PG than is provided.


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

