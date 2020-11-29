# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.0.0-build.14] - 2020-11-21
### Added
- Playback will now continue were it was stopped (but not yet sync to the server)
### Changed
### Deprecated
### Fixed
- Bug which prevented authentication from succeeding
### Removed

## [v1.0.0-build.13] - 2020-11-21
### Added
- DebugMode for more error information
- Season and Episode Selection in Series Page
- Option to enable HTTPS in Credentials Entry
### Changed
- DesignConfiguration is now EnvironmentValue instead of Object (performance optimization)
- Alerts will now display the exact error thrown when in debug mode
### Deprecated
### Fixed
- Client would occasionally crash when exiting a VideoPlayer
- padding in Card-Rows was corrected
### Removed


## [v1.0.0-build.12] - 2020-11-14
### Added
### Changed
- Alerts in Authentication Screen will now be more detailed
- Text Fields in Authentication Screen will no longer auto-capitalize or auto-correct
### Deprecated
### Fixed
- Alerts will now show in Authentication Screen
- App will no longer try to retrieve items before Authentication is successful
### Removed
