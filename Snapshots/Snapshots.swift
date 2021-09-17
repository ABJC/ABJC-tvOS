/*
 ABJC - tvOS
 Snapshots.swift

 ABJC is subject to the terms of the Mozilla Public
 License, v2.0. If a copy of the MPL was not distributed with this
 file, you can obtain one at https://mozilla.org/MPL/2.0/.

 Copyright 2021 Noah Kamara & ABJC Contributors
 Created on 17.09.21
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
            snapshot("ManualServerEntryUI")
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
            snapshot("ManualUserEntryUI")
        }
    }

    /// Test Collection VIews
    func testCollectionViews() {
        withApp(["enable-testing", "reset-stores", "authenticate", "user=user_hidden"]) { app in
            // Movies
            UITestHelpers.navigateToTab(with: "Movies", app: app)
            snapshot("MoviesTab")
            XCUIRemote.shared.press(.select)
            XCUIRemote.shared.press(.select)
            sleep(1)
            snapshot("MovieDetailView")
            XCUIRemote.shared.press(.down)
            sleep(1)
            add(UITestHelpers.takeScreenshot("MovieDetailView-2", .keepAlways))
            XCUIRemote.shared.press(.menu)

            // TV Shows
            UITestHelpers.navigateToTab(with: "TV Shows", app: app)
            snapshot("TVShowsTab")
            XCUIRemote.shared.press(.select)
            XCUIRemote.shared.press(.select)
            sleep(1)
            snapshot("TVShowsDetailView")
            XCUIRemote.shared.press(.down)
            sleep(1)
            add(UITestHelpers.takeScreenshot("TVShowsDetailView-2", .keepAlways))
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
            add(UITestHelpers.takeScreenshot("Preferences+InfoView", .keepAlways))
            XCUIRemote.shared.press(.menu)

            // Test navigating to "ClientView"
            UITestHelpers.findAndPressButton(clientViewLink, .down)
            XCTAssert(app.navigationBars["Client Preferences"].waitForExistence(timeout: 15.0))
            add(UITestHelpers.takeScreenshot("Preferences+ClientView", .keepAlways))
        }
    }
}
