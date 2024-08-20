//
//  FavoritesViewModelTests.swift
//  SportsWorldTests
//
//  Created by Sarah on 19/08/2024.
//

import XCTest
@testable import SportsWorld
import CoreData

class FavouritesViewModelTests: XCTestCase {
    var viewModel: FavouritesViewModel!
    var mockCoreDataManager: MockCoreDataManager!

    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
        viewModel = FavouritesViewModel()
        viewModel.coreDataManager = mockCoreDataManager
    }

    override func tearDown() {
        viewModel = nil
        mockCoreDataManager = nil
        super.tearDown()
    }

    func testLoadDataFromCoreData() {
        
        let mockFavourite = MockFavourite()
        mockFavourite.league_key = 1
        mockFavourite.league_name = "Premier League"
        mockFavourite.league_logo = "logo_url"
        mockCoreDataManager.favourites = [mockFavourite]

        viewModel.loadDatafromCoreData()
        
        
        XCTAssertEqual(viewModel.result?.first?.league_name, "Premier League")
    }
    
    func testRemoveFavourite() {
        let mockFavourite = MockFavourite()
        mockFavourite.league_key = 1
        mockFavourite.league_name = "Premier League"
        mockFavourite.league_logo = "logo_url"
        mockCoreDataManager.favourites = [mockFavourite]

        
        viewModel.loadDatafromCoreData()
        XCTAssertEqual(viewModel.result?.first?.league_key, 1)

        viewModel.removeFavourite(leagueKey: 1)
        mockCoreDataManager.favourites.removeAll { $0.league_key == 1 }

        viewModel.loadDatafromCoreData()
        XCTAssertTrue(viewModel.result?.isEmpty ?? true, "Expected result to be empty after removing the favourite.")
    }
    
    func testNoFavouritesStored() {
        mockCoreDataManager.favourites = []

        viewModel.loadDatafromCoreData()
        
        XCTAssertTrue(viewModel.result?.isEmpty ?? true, "Expected result to be empty when no favourites are stored.")
    }
    
    func testLoadDataWithMalformedData() {
       
        let mockFavourite = MockFavourite()
        mockFavourite.league_key = nil  
        mockFavourite.league_name = "Malformed League"
        mockFavourite.league_logo = "logo_url"
        mockCoreDataManager.favourites = [mockFavourite]

        viewModel.loadDatafromCoreData()

        XCTAssertEqual(viewModel.result?.first?.league_name, "Malformed League")
        XCTAssertNil(viewModel.result?.first?.league_key, "Expected league_key to be nil for malformed data.")
    }





}
