//
//  LeagueDetailsViewModelTests.swift
//  SportsWorldTests
//
//  Created by Sarah on 19/08/2024.
//

import XCTest
@testable import SportsWorld

class LeagueDetailsViewModelTests: XCTestCase {
    var viewModel: LeagueDetailsViewModel!
    var MockNetworkGeneric: MockNetworkGeneric!
    var mockCoreDataManager: MockCoreDataManager!

    override func setUp() {
        super.setUp()
        MockNetworkGeneric = SportsWorldTests.MockNetworkGeneric()
        mockCoreDataManager = MockCoreDataManager()
        viewModel = LeagueDetailsViewModel(sport: "football", leagueKey: 1, league: League())
        viewModel.network = MockNetworkGeneric
        viewModel.coreDataManager = mockCoreDataManager
    }

    override func tearDown() {
        viewModel = nil
        MockNetworkGeneric = nil
        mockCoreDataManager = nil
        super.tearDown()
    }

    func testLoadDataSuccess() {
        let expectedEvents = Events(result: [Match(event_home_team: "Team A", home_team_logo: "logo_url", event_date: "2024-08-20")])
        MockNetworkGeneric.resultToReturn = expectedEvents

        let expectation = self.expectation(description: "Data Binding")
        viewModel.bindResultToViewController = {
            expectation.fulfill()
        }

        viewModel.loadData()
        waitForExpectations(timeout: 2)

        XCTAssertEqual(viewModel.upEvents?.first?.event_home_team, "Team A")
    }
    
    func testLoadDataWithEmptyResponse() {
        let expectedEvents = Events(result: [])  
        MockNetworkGeneric.resultToReturn = expectedEvents

        let expectation = self.expectation(description: "Data Binding")
        viewModel.bindResultToViewController = {
            expectation.fulfill()
        }

        viewModel.loadData()
        waitForExpectations(timeout: 2)

        XCTAssertTrue(viewModel.upEvents?.isEmpty ?? false)
        XCTAssertTrue(viewModel.lateEvents?.isEmpty ?? false)
    }
    
    func testEditInCoreDataAddFavourite() {
        var league = League()
        league.league_key = 1
        league.league_name = "Premier League"
        league.league_logo = "logo_url"

        viewModel.editInCoreData(league: league, leagueKey: 1, isFavourite: false, sport: "football")

        XCTAssertTrue(mockCoreDataManager.isFavourited(leagueKey: 1))
    }

    func testEditInCoreDataRemoveFavourite() {
        var league = League()
        league.league_key = 1
        league.league_name = "Premier League"
        league.league_logo = "logo_url"
        
        mockCoreDataManager.addToFavourites(favLeague: league, sport: "football")
        XCTAssertTrue(mockCoreDataManager.isFavourited(leagueKey: 1))
        
        viewModel.editInCoreData(league: league, leagueKey: 1, isFavourite: true, sport: "football")
        XCTAssertFalse(mockCoreDataManager.isFavourited(leagueKey: 1))  // Check if the league was removed
    }
    
    func testDataBindingCalledOnLoad() {
        let expectedEvents = Events(result: [Match(event_home_team: "Team A", home_team_logo: "logo_url", event_date: "2024-08-20")])
        MockNetworkGeneric.resultToReturn = expectedEvents

        let expectation = self.expectation(description: "Data Binding")
        var isFulfilled = false
        
        viewModel.bindResultToViewController = {
            if !isFulfilled {
                XCTAssertEqual(self.viewModel.upEvents?.first?.event_home_team, "Team A")
                expectation.fulfill()
                isFulfilled = true
            }
        }

        viewModel.loadData()
        waitForExpectations(timeout: 5)
    }

    func testLoadDataWithDifferentEvents() {
        let upcomingEvents = Events(result: [Match(event_home_team: "Upcoming Team", home_team_logo: "logo_url_upcoming", event_date: "2024-08-21")])
        let latestEvents = Events(result: [Match(event_home_team: "Latest Team", home_team_logo: "logo_url_latest", event_date: "2024-08-22")])
        
        MockNetworkGeneric.resultToReturn = upcomingEvents
        viewModel.loadData()

        XCTAssertEqual(viewModel.upEvents?.first?.event_home_team, "Upcoming Team")
        
        MockNetworkGeneric.resultToReturn = latestEvents
        viewModel.loadData()
        
        XCTAssertEqual(viewModel.lateEvents?.first?.event_home_team, "Latest Team")
    }
    
    func testLoadDataWithLargeDataset() {
        let largeDataset = Events(result: Array(repeating: Match(event_home_team: "Team", home_team_logo: "logo_url", event_date: "2024-08-20"), count: 1000))
        MockNetworkGeneric.resultToReturn = largeDataset

        let expectation = self.expectation(description: "Data Binding")
        viewModel.bindResultToViewController = {
            expectation.fulfill()
        }

        viewModel.loadData()
        waitForExpectations(timeout: 5)

        XCTAssertEqual(viewModel.upEvents?.count, 1000, "Expected upEvents to have 1000 items.")
    }

    
    func testCoreDataManagerDependency() {
        var league = League()
        league.league_key = 1
        league.league_name = "Test League"
        league.league_logo = "logo_url"

        viewModel.editInCoreData(league: league, leagueKey: 1, isFavourite: false, sport: "football")
        
        XCTAssertTrue(mockCoreDataManager.isFavourited(leagueKey: 1), "Expected CoreDataManager to have added the league to favourites.")

        viewModel.editInCoreData(league: league, leagueKey: 1, isFavourite: true, sport: "football")
        
        XCTAssertFalse(mockCoreDataManager.isFavourited(leagueKey: 1), "Expected CoreDataManager to have removed the league from favourites.")
    }






    
    


}

