//
//  APITests.swift
//  ABJCTests
//
//  Created by Noah Kamara on 26.03.21.
//

import XCTest
@testable import ABJC

class APITests: XCTestCase {
    #warning("Change Server & Authentication Info")
    let host: String = "192.168.178.85"
    let port: Int = 8096
    let username: String = "jellyfin"
    let password: String = "password"
    
    var jellyfin: Jellyfin!
    
    var testMovieItem: APIModels.MediaItem? = nil
    var testSeriesItem: APIModels.MediaItem? = nil
    
    var itemQuery: String = "A"
    var peopleQuery: String = "A"
    
    override func setUpWithError() throws {
        let server = Jellyfin.Server(host, port)
        let client = Jellyfin.Client()
        
        let expect = expectation(description: "Waiting for Authorization")
        API.authorize(server, client, username, password) { result in
            switch result {
                case .success(let jellyfin):
                    self.jellyfin = jellyfin
                    API.items(jellyfin) { result in
                        switch result {
                            case .success(let items):
                                self.testMovieItem = items.first(where: { $0.type == .movie})
                                self.testSeriesItem = items.first(where: { $0.type == .series})
                            case .failure(_ ): break
                        }
                        expect.fulfill()
                    }
                case .failure(let error):
                    print(error)
                    fatalError("Couldn't authorize")
            }
        }
        
        wait(for: [expect], timeout: 60.0)
    }

    
    func testSystemInfo() {
        let expect = expectation(description: "")
        
        API.systemInfo(self.jellyfin) { result in
            do {
                _ = try result.get()
            } catch let error {
                print(error)
                XCTFail("Failed API.systemInfo")
            }
            
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 60.0)
    }
    
    func testLatest() {
        
    }
    
    func testFavorites() {
        
    }

    func testItems() {
        let expect = expectation(description: "")
        
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
    
    func testMovie() {
        let expect = expectation(description: "")
        
        guard let movieId = testMovieItem?.id else {
            XCTFail("Failed API.movie - No Movie found in Library")
            return
        }
        
        API.movie(jellyfin, movieId) { result in
            do {
                _ = try result.get()
            } catch let error {
                print(error)
                XCTFail("Failed API.movie")
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 60.0)
    }
    
    func testSeasons() {
        let expect = expectation(description: "")
        
        guard let seriesId = testSeriesItem?.id else {
            XCTFail("Failed API.seasons - No Series found in Library")
            return
        }
        
        API.seasons(jellyfin, seriesId) { result in
            do {
                _ = try result.get()
            } catch let error {
                print(error)
                XCTFail("Failed API.seasons")
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 60.0)
    }
    
    func testEpisodes() {
        let expect = expectation(description: "")
        
        guard let seriesId = testSeriesItem?.id else {
            XCTFail("Failed API.episodes - No Series found in Library")
            return
        }
        
        API.episodes(jellyfin, seriesId) { result in
            do {
                _ = try result.get()
            } catch let error {
                print(error)
                XCTFail("Failed API.episodes")
            }
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 60.0)
    }
    
    func testSearch() {
        let searchItems = expectation(description: "")
        let searchPeople = expectation(description: "")
        
        API.searchItems(jellyfin, itemQuery) { result in
            do {
                _ = try result.get()
            } catch let error {
                print(error)
                XCTFail("Failed API.searchItems")
            }
            searchItems.fulfill()
        }
        
        API.searchPeople(jellyfin, peopleQuery) { result in
            do {
                _ = try result.get()
            } catch let error {
                print(error)
                XCTFail("Failed API.searchPeople")
            }
            searchPeople.fulfill()
        }
        
        wait(for: [searchItems, searchPeople], timeout: 60.0)
    }
}
