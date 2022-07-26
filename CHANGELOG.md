## 2.2.0

- Fixed issue in root file of the library
- The functional_builder.dart is experimental and so is not part of the library. However in the previous release, this file was not excluded

## 2.1.0

- Updated to be compatible with Flutter 3
- Removed unnecessary null checks for WidgetsBinding.instance

## 2.0.0

- Added event system to the library
- Added `TurboEvent` to represent an event associated with a TurboController
- Added `event` function to `TurboController` to provide the appropriate `TurboEvent` instance
- Updated attach, _detach, refresh and other functions have been updated to use the event system
- Added check to prevent multiple attachments of the same controller for a widget
- More documentation, added documentation for the new event system and for elements that didn't have any previously
- Updated example.dart and README.md to reflect the changes

## 1.2.1

- Updated README

## 1.2.0

- refresh function is now asynchronous. It can be invoked according to the situation
- It is also asynchronous by default so as to prevent frame drops in complex codebases
- Added TurboBuilder to make the workflow more flexible and easier
- Added more documentation
- Updated README with example of TurboBuilder

## 1.1.1

- Updated README and package metadata

## 1.1.0

- Added ability to attach controllers of different types to the same widget
- Added ability to manually detach a controller from a widget
- Added documentation comments
- Updated README.md with a short example
- Added example.dart

## 1.0.0

- Added `TurboController`
- Added `TurboWidget`
- Added `TurboState`
- Added `TurboElement`

## 0.0.1

- Initial Commit