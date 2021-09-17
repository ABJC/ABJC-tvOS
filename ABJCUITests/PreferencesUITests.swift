//
//  PreferencesUITests.swift
//  PreferencesUITests
//
//  Created by Noah Kamara on 15.09.21.
//

import XCTest

extension Bool {
    var flip: Bool { return !self }
}

class PreferencesUITests: XCTestCase {
    let app = XCUIApplication()
    let constants = UITestConstants(.init(for: PreferencesUITests.self))

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launchArguments = [
            "enable-testing",
            "reset-stores",
            "authenticate",
            "user=user_hidden",
        ]
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testNavigationLinksUI() {
        UITestHelpers.navigateToTab(with: "Preferences", app: app)

        // UI Elements
        let infoViewLink = app.cells["General Information"]
        let clientViewLink = app.cells["Client"]

        // Test whether all Preferences NavigationLinks are displaying
        XCTAssert(infoViewLink.waitForExistence(timeout: 15.0))
        XCTAssert(clientViewLink.waitForExistence(timeout: 15.0))

        // Test navigating to "InfoView"
        UITestHelpers.findAndPressButton(infoViewLink, .down)
        XCTAssert(app.navigationBars["General Information"].waitForExistence(timeout: 15.0))
        XCUIRemote.shared.press(.menu)

        // Test navigating to "ClientView"
        UITestHelpers.findAndPressButton(clientViewLink, .down)
        XCTAssert(app.navigationBars["Client Preferences"].waitForExistence(timeout: 15.0))
        XCUIRemote.shared.press(.menu)
    }

    /// Test UI Elements in  InfoView
    func testInfoViewUI() {
        // Navigate to tab
        UITestHelpers.navigateToTab(with: "Preferences", app: app)

        // UI Elements
        let viewLink = app.cells["General Information"]
        XCTAssert(viewLink.waitForExistence(timeout: 15.0))

        // Navigate to View
        XCUIRemote.shared.press(.select)
        UITestHelpers.findAndPressButton(viewLink, .down)
        sleep(1)

        // Test View UI
        let rows = [
            "inforow-Name",
            "inforow-System Architecture",
            "inforow-Operating System",
            "inforow-Identifier",
            "inforow-Jellyfin Version",
            "inforow-Local Address",
            "inforow-IPv6",
            "inforow-IPv4",
            "inforow-HTTP Port",
            "inforow-HTTPS Port",
            "inforow-AutoDiscovery",
        ]

        // Test whether all rows exist
        for row in rows {
            let element = app.buttons[row]
            XCTAssert(element.exists, "Element \(row) exists")
            XCTAssert(!element.label.contains("ERR"), "Element \(row) failed with error")
        }

        // Test whether rows are focusable
        for element in app.cells.allElementsBoundByIndex {
            XCTAssert(element.hasFocus, "Element \(element.label) has focus")
            XCUIRemote.shared.press(.down)
        }
    }

    /// Test UI Elements in  CientView
    func testClientViewUI() {
        // Navigate to tab
        UITestHelpers.navigateToTab(with: "Preferences", app: app)

        // UI Elements
        let viewLink = app.cells["Client"]
        XCTAssert(viewLink.waitForExistence(timeout: 15.0))

        // Navigate to View
        XCUIRemote.shared.press(.select)
        UITestHelpers.findAndPressButton(viewLink, .down)

        sleep(1)
        let rows = [
            "togglerow-Always Show Titles",
            "Poster Type",
            "Collection Grouping",
        ]

        // Test whether all rows exist
        for row in rows {
            let element = app.descendants(matching: .any)[row]
            XCTAssert(element.exists, "Element \(row) exists")
        }

        // Test whether rows are focusable
        for element in app.cells.allElementsBoundByIndex {
            XCTAssert(element.hasFocus, "Element \(element.label) has focus")
            XCUIRemote.shared.press(.down)
        }
    }

    func inPreferencePane(_ action: () -> Void) {
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

    /// Test Preference "Always Show Titles"
    func testAlwaysShowTitlesPreference() {
        // Test "Always Show Titles" - On
        inPreferencePane {
            let showsTitlesTgl = app.switches["togglerow-Always Show Titles"]
            XCTAssert(showsTitlesTgl.waitForExistence(timeout: 15.0))
            XCTAssert(showsTitlesTgl.value as! String == "Off", "Default Value is set correctly")
            XCUIRemote.shared.press(.select)
        }
        UITestHelpers.navigateToTab(with: "Movies", app: app)
        sleep(2)
        for cell in app.cells.allElementsBoundByIndex {
            XCTAssert(!cell.buttons.firstMatch.label.isEmpty)
        }
        UITestHelpers.navigateToTab(with: "TV Shows", app: app)
        sleep(2)
        for cell in app.cells.allElementsBoundByIndex {
            XCTAssert(!cell.buttons.firstMatch.label.isEmpty)
        }

        // Test "Always Show Titles" - Off
        inPreferencePane {
            let showsTitlesTgl = app.switches["togglerow-Always Show Titles"]
            XCTAssert(showsTitlesTgl.waitForExistence(timeout: 15.0))
            XCTAssert(showsTitlesTgl.value as! String == "On", "Value is now On after setting")
            XCUIRemote.shared.press(.select)
        }
        UITestHelpers.navigateToTab(with: "Movies", app: app)
        sleep(2)
        for cell in app.cells.allElementsBoundByIndex {
            print(cell.debugDescription)
            XCTAssert(cell.buttons.firstMatch.label.isEmpty)
        }
        UITestHelpers.navigateToTab(with: "TV Shows", app: app)
        sleep(2)
        for cell in app.cells.allElementsBoundByIndex {
            XCTAssert(cell.buttons.firstMatch.label.isEmpty)
        }
    }

    /// Test Preference "Poster Type"
    func testPosterTypePreference() {
        let posterCellSize = CGSize(width: 225.0, height: 340.0)
        let wideCellSize = CGSize(width: 548, height: 300)

        // Test "Poster Type" - Poster
        inPreferencePane {
            let posterTypeCell = app.cells["Poster Type"]

            let selection = app.cells["Wide"]
            UITestHelpers.findAndPressButton(posterTypeCell, .down)
            UITestHelpers.findAndPressButton(selection, .down)

            XCTAssert(posterTypeCell.waitForExistence(timeout: 15.0))
            XCTAssert(posterTypeCell.buttons.firstMatch.value as! String == "Wide")
        }

        UITestHelpers.navigateToTab(with: "Movies", app: app)
        sleep(2)
        for cell in app.cells.allElementsBoundByIndex {
            XCTAssert(cell.frame.size == wideCellSize)
        }
        UITestHelpers.navigateToTab(with: "TV Shows", app: app)
        sleep(2)
        for cell in app.cells.allElementsBoundByIndex {
            XCTAssert(cell.frame.size == wideCellSize)
        }

        // Test "Poster Type" - Wide
        inPreferencePane {
            let posterTypeCell = app.cells["Poster Type"]

            let selection = app.cells["Poster"]
            UITestHelpers.findAndPressButton(posterTypeCell, .down)
            UITestHelpers.findAndPressButton(selection, .down)

            XCTAssert(posterTypeCell.waitForExistence(timeout: 15.0))
            XCTAssert(posterTypeCell.buttons.firstMatch.value as! String == "Poster")
        }

        UITestHelpers.navigateToTab(with: "Movies", app: app)
        sleep(2)
        for cell in app.cells.allElementsBoundByIndex {
            XCTAssert(cell.frame.size == posterCellSize)
        }
        UITestHelpers.navigateToTab(with: "TV Shows", app: app)
        sleep(2)
        for cell in app.cells.allElementsBoundByIndex {
            XCTAssert(cell.frame.size == posterCellSize)
        }
    }

    /// Test Preference "Collection Grouping"
    func testCollectionGroupingPreference() {
        func testGrouping(_ grouping: String, isFormatCorrect: (String) -> Bool) {
            inPreferencePane {
                let prefCell = app.cells["Collection Grouping"]

                let selection = app.cells[grouping]
                UITestHelpers.findAndPressButton(prefCell, .down)
                UITestHelpers.findAndPressButton(selection, .down)

                XCTAssert(prefCell.waitForExistence(timeout: 15.0))
                XCTAssert(prefCell.buttons.firstMatch.value as! String == grouping)
            }

            UITestHelpers.navigateToTab(with: "Movies", app: app)
            sleep(2)
            var collView = app.collectionViews.firstMatch
            for section in collView.staticTexts.allElementsBoundByIndex {
                XCTAssert(section.identifier.contains(grouping), "Grouping is Correct")
                XCTAssert(isFormatCorrect(section.label), "Format is Correct")
            }

            UITestHelpers.navigateToTab(with: "TV Shows", app: app)
            sleep(2)
            collView = app.collectionViews.firstMatch
            for section in collView.staticTexts.allElementsBoundByIndex {
                XCTAssert(section.identifier.contains(grouping), "Grouping is Correct")
                XCTAssert(isFormatCorrect(section.label), "Format is Correct")
            }
        }

        // Test "Collection Grouping" - "By Decade"
        testGrouping("By Decade") { string in
            (string.count == 5) && string.hasSuffix("s") && !string.prefix(4).contains(where: \.isNumber.flip)
        }

        // Test "Collection Grouping" - "By Year"
        testGrouping("By Year") { string in
            string.count == 4 && !string.contains(where: \.isNumber.flip)
        }

        // Test "Collection Grouping" - "By Title"
        testGrouping("By Title") { string in
            print(string, string.count == 1, string.first!.isLetter, string == "#")
            return string.count == 1 && string.first!.isLetter || string == "#"
        }

        // Test "Collection Grouping" - "By Genre"
        testGrouping("By Genre") { _ in
            true
        }
    }
}
