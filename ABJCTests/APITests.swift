//
//  APITests.swift
//  ABJCTests
//
//  Created by Noah Kamara on 26.03.21.
//

import XCTest
@testable import ABJC

class APITests: XCTestCase {
    var jellyfin: Jellyfin!

    override func setUpWithError() throws {
        let server = Jellyfin.Server("192.168.178.35", 8096)
        let client = Jellyfin.Client()
        let username = "jellyfin"
        let password = "password"
        
        let expect = expectation(description: "Waiting for Authorization")
        API.authorize(server, client, username, password) { result in
            switch result {
                case .success(let jellyfin):
                    self.jellyfin = jellyfin
                case .failure(let error):
                    print(error)
                    fatalError("Couldn't authorize")
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 60.0)
    }

    
    func testSystemInfo() {
        let expect = expectation(description: "System Info")
        
        API.systemInfo(self.jellyfin) { result in
            do {
                _ = try result.get()
            } catch let error {
                print(error)
                XCTFail("Fetching System Info Failed")
            }
            
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 60.0)
    }

    func testItems() {
        let expect = expectation(description: "Fetching Items")
        
        API.items(jellyfin) { result in
            do {
                _ = try result.get()
            } catch let error {
                print(error)
                XCTFail("Fetching Items Failed")
            }
            
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 60.0)
    }
}
