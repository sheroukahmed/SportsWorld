//
//  FavoritesViewModelTests.swift
//  SportsWorldTests
//
//  Created by Sarah on 19/08/2024.
//

import XCTest
@testable import SportsWorld

final class FavoritesViewModelTests: XCTestCase {
    
    var viewModel: FavouritesViewModel!
    var mockCoreDataManager: MockCoreDataManager!


    override func setUpWithError() throws {
        mockCoreDataManager = MockCoreDataManager()
        viewModel = FavouritesViewModel()
        viewModel.coreDataManager = mockCoreDataManager
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockCoreDataManager = nil
    }

    func testAddingToFavourites() {
        let league = League()
        league.league_key = 123
        league.league_name = "Premier League"
        league.league_logo = "logo_url"
        
        viewModel.coreDataManager.addToFavourites(favLeague: league, sport: "Football")
        
        XCTAssertEqual(mockCoreDataManager.mockFavourites.count, 1)
        XCTAssertEqual(mockCoreDataManager.mockFavourites.first?.value(forKey: "league_name") as? String, "Premier League")
    }
    
    
    func testLoadDataFromCoreData() {
           let expectation = self.expectation(description: "Data fetched from Core Data and bound to view controller")

           viewModel.bindResultToViewController = {
               XCTAssertNotNil(self.viewModel.result)
               XCTAssertEqual(self.viewModel.result?.count, 2) 
               expectation.fulfill()
           }

           viewModel.loadDatafromCoreData()
           waitForExpectations(timeout: 5)
       }
   }
