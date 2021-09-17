//
//  PlaybackUITests.swift
//  PlaybackUITests
//
//  Created by Noah Kamara on 14.09.21.
//

import XCTest

class PlaybackUITests: XCTestCase {
    let app = XCUIApplication()
    let constants = UITestConstants(.init(for: PlaybackUITests.self))

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launchArguments = [
            "enable-testing",
            "authenticate",
            "user=user_hidden",
        ]
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testPlaybackViewDisplays() throws {
        let moviesTab = app.buttons["Movies"]
        XCTAssert(moviesTab.waitForExistence(timeout: 15.0))
        XCUIRemote.shared.press(.down)
        XCUIRemote.shared.press(.select)

        let playBtn = app.buttons["playBtn"]
        XCTAssert(playBtn.waitForExistence(timeout: 15.0), "Play BTN is exists")
        XCUIRemote.shared.press(.select)

        let playerView = app.otherElements["playerView"]
        sleep(2)
        print(app.debugDescription)
        XCTAssert(playerView.waitForExistence(timeout: 15.0), "PlayerView exists")

        sleep(10)
    }
}
