# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.0.0-build.25] - [2021-06-27]
### Added
- Added User Selection View
- Added User switching
- Added path configuration option (Support for BaseURL)
### Changed
- Improved Server Selection View
- Improved Manual Server Selection View
- Improved Credentials View
- URLImage was updated to 3.0.1
### Deprecated
### Fixed 
### Removed

## [v1.0.0-build.24] - [2021-06-03]
### Added
### Changed
### Deprecated
### Fixed 
- Playback of TV Shows should now be possible
- App will no longer crash when logging out
### Removed

## [v1.0.0-build.23] - [2021-05-20]
### Added
- It is now possible to change the type of poster that is displayed for media items
- Item detail pages have a backdrop (Blurhash)
- Item detail pages show a poster for the item
### Changed
- Updated URLImage to Version 3.0.1
### Deprecated
### Fixed 
### Removed

## [v1.0.0-build.22] - [2021-05-10]
### Added
### Changed
### Deprecated
### Fixed
- Fixed a crash that would occur if an UDP response didn't include a port (thanks to @stephenb10 on GitHub)
### Removed

## [v1.0.0-build.21] - [2021-05-08]
### Added
- documentation for SessionStore
- documentation for PreferencesStore
- some documentation for UI
### Changed
### Deprecated
### Fixed
### Removed
- all GeometryReaders were removed (responsible for majority of crashes in build 20)


## [v1.0.0-build.20] - 2021-05-02
### Added
### Changed
### Deprecated
### Fixed
- App will no longer crash when an Thumbnail URL couldn't be generated
- App will no longer crash when requests to a jellyfin server result in an error
### Removed

## [v1.0.0-build.19] - 2021-04-26
### Added
- Playstate reporting (synching progress with server)
- Preferences > General > Libary Info
- Preferences > General > User Info
- Option to group library by different categories (alphabetically, genre, release year, release decade)
### Changed
- Preferences: Server Info now on general info page
- Option to always show titles for items is no longer beta flag
- Series Detail view has an improved season switcher
- Series Detail view will update current season when focussing on an episode from another season
### Deprecated
### Fixed
### Removed
- beta flag for showing titles

## [v1.0.0-build.17] - 2021-04-05
### Added
### Changed
- reverted back to v1.0.0-build.15
### Deprecated
### Fixed
### Removed

## [v1.0.0-build.16] - 2021-03-10
### Added
- Playstate reporting - will now report playstate back to server (playback position) periodically
- Continue - will now show "continue" instead of "play"-button when continuing
### Changed
- Playstate reporting & continuation are no longer beta flags, but fully implemented
- Rows for Media Cards are no longer Lazy Stacks (due to performance issues)
### Deprecated
### Fixed
### Removed
- Beta Flags: Playback Continuation, Playback Reporting

## [v1.0.0-build.15] - 2021-03-02
### Added
- Beta Flags now include the option to always show media titles
### Changed
### Deprecated
### Fixed
- DebugMode will now show more useful messages
### Removed

## [v1.0.0-build.14] - 2020-11-22
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
