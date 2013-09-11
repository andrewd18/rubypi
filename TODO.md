Core Features
=============

* Add cycle times to all buildings.
* Add a "pipeline view" or a "chain view" or something that shows the product build cycle. Planet scope only.
* Add product unit and volume output per hour per building.
* Warn when there are product overages in the pipeline.
* Warn when there are product underages in the pipeline.
* Hook up to EVE character skills.
* Warn when the settings exceed character skills.


User Interface Improvements
===========================

* When adding product, let user type in value (along with slider).
* When removing product, let user type in value (along with slider).
* When transferring product, let user type in value (along with slider).
* Separate one-time build cost from recurring import/export costs.
* Create a View Column Renderer that auto-converts raw ISK values to a human-readable value. Use for all views with isk columns.
* Images
  - Brighten the planet screenshots across the board. Lava, for example, just looks black.
  - Add images for every product. Show where appropriate.
* Building Drawing Area
  - Add tooltips on hover.
  - Do something visual on two-step building processes (adding, editing, or deleting links, expedited transfers) that shows you're on step two.
* Transfer Products Dialog
  - Add a warning when the user tries to transfer products to a destination that isn't selected yet.
  - Add a warning when the user tries to transfer products from one building to itself.



Code Cleanup
============

* Unit Tests
  - Write controller tests.
  - Write accepts-controller-API tests for the views.
* Do my own serialization of @pi_configuration that doesn't rely on a straight YAML dump.
  - Mostly mitigated now by the 0.0.12 model/view/controller revamp. Having the object IDs change every save/load is annoying but livable.
* Make "signal_handler_block(signal_id){}" into a GTK helper or something less clunky.
* Unify the export_to_yaml dialog in the main ruby_pi app and the pi_configuration_view controller
* Simplify the building_drawing_area class down from 700-some lines.
* Speed up the building_drawing_area class' draw routines so it feels snappier.
* Rework the API between the building_drawing_area and the tool palette. Too many responsibilities split across classes.
* Speed up the redraw routine for the pi_configuration_view's planet list.

Packaging & Release
===================

* Windows
  - Research why the EXE is so huge.
* Mac
  - Lure in some Mac beta testers. Cookies? Apple fritters?

