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

}
