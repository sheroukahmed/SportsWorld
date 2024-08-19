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
        let expectedEvents = Events(result: [])  // Empty events list
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
    
    


}

