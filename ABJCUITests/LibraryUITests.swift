//
//  LibraryUITests.swift
//  LibraryUITests
//
//  Created by Noah Kamara on 16.09.21.
//

import XCTest

class LibraryUITests: XCTestCase {
    let app = XCUIApplication()
    let constants = UITestConstants(.init(for: LibraryUITests.self))
    let collectionViewTabs = ["Movies", "TV Shows"]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launchArguments = [
            "enable-testing",
            "reset-stores",
            "authenticate",
            "user=user_hidden"
        ]
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    /// Test Collection Views (Movies, TV Shows)
    func testCollectionViews() throws {
        for tab in collectionViewTabs {
            UITestHelpers.navigateToTab(with: tab, app: app)
            sleep(2)
            // Take Screenshot
            add(UITestHelpers.takeScreenshot("CollectionView-\(tab)"))
            XCTAssertFalse(app.alerts["Failed to load items"].exists, "No Alert is Displayed")
            XCTAssert(!app.collectionViews.allElementsBoundByIndex.isEmpty, "Cells are displayed")
        }
    }

    /// Test Search View
    func testSearchView() throws {
        XCTExpectFailure("Not Implemented Yet")
        XCTFail("Not Implemented Yet")
    }

    /// Test Watch Now View
    func testWatchNowView() throws {
        XCTExpectFailure("Not Implemented Yet")
        XCTFail("Not Implemented Yet")
    }

    /// Test Correct DetailViews
    func testDetailViewsAppear() {
        func testCollectionView(tab: String, detailViewId: String) {
            UITestHelpers.navigateToTab(with: tab, app: app)
            sleep(1)
            XCUIRemote.shared.press(.select)

            let collectionView = app.collectionViews.firstMatch
            XCTAssert(collectionView.exists, "Collection View is displayed")

            for row in collectionView.scrollViews.allElementsBoundByIndex {
                let rowHasFocus = row.descendants(matching: .button).allElementsBoundByIndex.contains(where: \.hasFocus)
                XCTAssert(rowHasFocus, "Row has Focus")
                let cells = row.cells.allElementsBoundByIndex

                // Iterate forwards
                for cell in cells {
                    // Test if cell has focus
                    XCTAssert(cell.descendants(matching: .button).allElementsBoundByIndex.contains(where: \.hasFocus), "Cell has Focus")

                    // Open Detail View & Test if correct one is displayed
                    XCUIRemote.shared.press(.select)
                    XCTAssert(app.scrollViews[detailViewId].waitForExistence(timeout: 15.0), "Detail View was displayed")

                    // Close Detail View and test if cell remains selected
                    XCUIRemote.shared.press(.menu)
                    XCTAssert(cell.waitForExistence(timeout: 15.0))
                    XCTAssert(cell.descendants(matching: .button).allElementsBoundByIndex.contains(where: \.hasFocus), "Cell has Focus")
                    XCUIRemote.shared.press(.right)
                }

                // Iterate backwards
                for cell in cells.reversed() {
                    XCTAssert(cell.descendants(matching: .button).allElementsBoundByIndex.contains(where: \.hasFocus), "Cell has Focus")
                    XCUIRemote.shared.press(.left)
                }
                XCUIRemote.shared.press(.down)
            }
        }

        // Test Movie Detail View
        testCollectionView(tab: "Movies", detailViewId: "movieDetailView")

        // Test Series Detail View
        testCollectionView(tab: "TV Shows", detailViewId: "seriesDetailView")
    }

    /// Test Movie Detail View UI Elements
    func testMovieDetailViewUI() {
        UITestHelpers.navigateToTab(with: "Movies", app: app)
        sleep(1)
        XCUIRemote.shared.press(.select)
        XCUIRemote.shared.press(.select)

        // Take Screenshot
        add(UITestHelpers.takeScreenshot("MovieDetailViewUI"))

        // Elements
        let titleLbl = app.staticTexts["titleLbl"].firstMatch
        let overviewLbl = app.staticTexts["overviewLbl"].firstMatch
        let peopleViewLabel = app.staticTexts["peopleView"].firstMatch
        let peopleViewRow = app.scrollViews["peopleView"].firstMatch
        let recommendedViewLabel = app.staticTexts["recommendedView"].firstMatch
        let recommendedViewRow = app.scrollViews["recommendedView"].firstMatch

        // Test for existense
        XCTAssert(titleLbl.waitForExistence(timeout: 15.0))
        XCTAssert(overviewLbl.waitForExistence(timeout: 15.0))
        print(app.debugDescription)
        XCTAssert(peopleViewLabel.waitForExistence(timeout: 15.0))
        XCTAssert(peopleViewRow.waitForExistence(timeout: 15.0))
        XCTAssert(recommendedViewLabel.waitForExistence(timeout: 15.0))
        XCTAssert(recommendedViewRow.waitForExistence(timeout: 15.0))

        // Test labels
        XCTAssert(!titleLbl.label.isEmpty)
        XCTAssert(!overviewLbl.label.isEmpty)
        XCTAssert(!peopleViewLabel.label.isEmpty)
        XCTAssert(!recommendedViewLabel.label.isEmpty)

        // Test rows
        for peopleCell in peopleViewRow.otherElements.firstMatch.children(matching: .button).allElementsBoundByIndex {
            XCTAssert(!peopleCell.label.isEmpty)
        }

        for recCell in recommendedViewRow.otherElements.firstMatch.children(matching: .button).allElementsBoundByIndex {
            XCTAssert(!recCell.label.isEmpty)
        }
    }

    /// Test Movie Detail View Navigation
    func testMovieDetailViewNavigation() {
        XCTExpectFailure("Not Implemented Yet")
        XCTFail("Not Implemented Yet")
    }

    /// Test Series Detail View
    func testSeriesDetailView() {
        XCTExpectFailure("Not Implemented Yet")
        XCTFail("Not Implemented Yet")
    }
}
