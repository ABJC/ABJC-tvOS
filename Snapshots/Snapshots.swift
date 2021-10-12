/*
 ABJC - tvOS
 Snapshots.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 10/12/21
 */

import XCTest

class Snapshots: XCTestCase {
    var constants = UITestConstants(.init(for: Snapshots.self))

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func withApp(_ arguments: [String], _ action: (XCUIApplication) -> Void) {
        let app = XCUIApplication()
        app.launchArguments = arguments
        setupSnapshot(app)
        app.launch()
        action(app)
        app.terminate()
    }

    /// Test Authentication Views
    func testAuthenticationViews() {
        // Server Selection
        withApp(["enable-testing", "reset-stores"]) { app in
            // ServerSelectionUI
            snapshot("ServerSelectionUI")
            UITestHelpers.findAndPressButton(app.buttons["enterServerManuallyBtn"], .down)

            // ManualServerEntryUI
            snapshot("ManualServerEntryUI-Empty")
            let hostField = app.textFields["hostField"]
            let portField = app.textFields["portField"]
            let pathField = app.textFields["pathField"]

            // Enter Values
            UITestHelpers.withOpenTextField(hostField, .down) {
                hostField.clearAndEnterText(text: "HOST")
            }
            UITestHelpers.withOpenTextField(portField, .down) {
                portField.clearAndEnterText(text: "PORT")
            }
            UITestHelpers.withOpenTextField(pathField, .down) {
                pathField.clearAndEnterText(text: "PATH")
            }

            snapshot("ManualServerEntryUI-Filled")
        }

        // User Selection
        withApp(["enable-testing", "reset-stores"]) { app in
            UITestHelpers.findAndPressButton(app.buttons["enterServerManuallyBtn"], .down)
            UITestHelpers.authConnectToServer(
                app,
                host: constants.serverHost,
                port: constants.serverPort,
                path: constants.serverPath
            )

            // UserSelectionUI
            snapshot("UserSelectionUI")

            UITestHelpers.findAndPressButton(app.buttons["manualUserBtn"], .down)

            // ManualUserEntryUI
            snapshot("ManualUserEntryUI-Empty")

            let usernameField = app.textFields["usernameField"]
            let passwordField = app.secureTextFields["passwordField"]
            let continueButton = app.buttons["continueBtn"]
            // Enter Values
            UITestHelpers.withOpenTextField(usernameField, .down) {
                usernameField.clearAndEnterText(text: "USERNAME")
            }
            UITestHelpers.withOpenTextField(passwordField, .down) {
                passwordField.clearAndEnterText(text: "PASSWORD")
            }
            snapshot("ManualUserEntryUI-Filled")
        }
    }

    /// Test Collection VIews
    func testCollectionViews() {
        func inPreferencePane(_ app: XCUIApplication, _ action: () -> Void) {
            // Navigate to tab
            UITestHelpers.navigateToTab(with: "Preferences", app: app)

            // UI Elements
            let viewLink = app.cells["Client"]
            XCTAssert(viewLink.waitForExistence(timeout: 15.0))

            // Navigate to View
            XCUIRemote.shared.press(.select)
            UITestHelpers.findAndPressButton(viewLink, .down)
            sleep(1)
            action()
            XCUIRemote.shared.press(.menu)
        }

        // Snapshot Poster Types
        withApp(["enable-testing", "reset-stores", "authenticate", "user=user_hidden"]) { app in
            // Movies
            UITestHelpers.navigateToTab(with: "Movies", app: app)
            snapshot("MoviesTab-postertype=poster")

            // TV Shows
            UITestHelpers.navigateToTab(with: "TV Shows", app: app)
            snapshot("TVShowsTab-postertype=poster")

            inPreferencePane(app) {
                let posterTypeCell = app.cells["Poster Type"]

                let selection = app.cells["Wide"]
                UITestHelpers.findAndPressButton(posterTypeCell, .down)
                UITestHelpers.findAndPressButton(selection, .down)
            }

            // Movies
            UITestHelpers.navigateToTab(with: "Movies", app: app)
            snapshot("MoviesTab-postertype=wide")

            // TV Shows
            UITestHelpers.navigateToTab(with: "TV Shows", app: app)
            snapshot("TVShowsTab-postertype=wide")
        }

        // Snapshot Grouping Types
        withApp(["enable-testing", "reset-stores", "authenticate", "user=user_hidden"]) { app in
            let groupings = [
                "By Decade",
                "By Year",
                "By Title",
                "By Genre"
            ]

            for grouping in groupings {
                inPreferencePane(app) {
                    let prefCell = app.cells["Collection Grouping"]

                    let selection = app.cells[grouping]
                    UITestHelpers.findAndPressButton(prefCell, .down)
                    UITestHelpers.findAndPressButton(selection, .down)

                    XCTAssert(prefCell.waitForExistence(timeout: 15.0))
                    XCTAssert(prefCell.buttons.firstMatch.value as! String == grouping)
                }

                let groupingId = grouping.replacingOccurrences(of: " ", with: "").lowercased()
                // Movies
                UITestHelpers.navigateToTab(with: "Movies", app: app)
                snapshot("MoviesTab-grouping=\(groupingId)")

                // TV Shows
                UITestHelpers.navigateToTab(with: "TV Shows", app: app)
                snapshot("TVShowsTab-grouping=\(groupingId)")
            }
        }
    }

    /// Test "Watch Now"
//    func testWatchNowView() {
//        withApp(["enable-testing", "reset-stores", "authenticate", "user=user_hidden"]) { app in
//            UITestHelpers.navigateToTab(with: "Watch Now", app: app)
//            snapshot("WatchNowTab")
//        }
//    }

    /// Test "Preferences"
    func testPreferencesView() {
        withApp(["enable-testing", "reset-stores", "authenticate", "user=user_hidden"]) { app in
            UITestHelpers.navigateToTab(with: "Preferences", app: app)
            snapshot("PreferencesTab")

            let infoViewLink = app.cells["General Information"]
            let clientViewLink = app.cells["Client"]

            // Test navigating to "InfoView"
            UITestHelpers.findAndPressButton(infoViewLink, .down)
            XCTAssert(app.navigationBars["General Information"].waitForExistence(timeout: 15.0))
            snapshot("Preferences+InfoView")
            XCUIRemote.shared.press(.menu)

            // Test navigating to "ClientView"
            UITestHelpers.findAndPressButton(clientViewLink, .down)
            XCTAssert(app.navigationBars["Client Preferences"].waitForExistence(timeout: 15.0))
            snapshot("Preferences+ClientView")
        }
    }
}
