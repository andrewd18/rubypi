Core Features
=============

* Add CCP disclaimer, etc. to About box.
* Building View
  - Add view for Storage Facility.
  - Add view for Launchpad.
* Prevent user from adding buildings to a planet that the planet doesn't support.
* Add storage spaces to every building.
* Add links.
  - Auto-populate?
* Add cycle times to all buildings.
* Add product unit and volume output per building.
* Warn when there are product overages in the pipeline.
* Warn when there are product underages in the pipeline.
* Hook up to EVE character skills.
* Warn when the settings exceed character skills.


User Interface Improvements
===========================

* Images
  - Brighten the planet screenshots across the board. Lava, for example, just looks black.
* User should be able to see extractor heads in the edit extractor window.
* Add images for every product. Show them where appropriate.
* Warn when buildings use more CPU than is provided.
* Warn when buildings use more PG than is provided.
* Allow the user to add more than six planets if they're doing multi-character PI chains *shudder*.


Code Cleanup
============

* Unify the stats boxes for planets.
* Replace the hack I have to fix all the weird-looking views when the window gets resized with real code.
* Unit Tests
  - Figure out how to test event hooks in unit tests so I can fully test views.
  - Keep adding more!


Packaging & Release
===================

* Windows
  - Research why the EXE is so huge.
* Mac
  - Lure in some Mac beta testers. Cookies? Apple fritters?

