//
//  TeamsViewModelTests.swift
//  SportsWorldTests
//
//  Created by Sarah on 19/08/2024.
//

import XCTest
@testable import SportsWorld

class TeamsViewModelTests: XCTestCase {
    var viewModel: TeamsViewModel!
    var MockNetworkGeneric: MockNetworkGeneric!

    override func setUp() {
        super.setUp()
        MockNetworkGeneric = SportsWorldTests.MockNetworkGeneric()
        viewModel = TeamsViewModel()
        viewModel.network = MockNetworkGeneric
    }

    override func tearDown() {
        viewModel = nil
        MockNetworkGeneric = nil
        super.tearDown()
    }

    func testLoadDataSuccess() {
        let expectedTeam = Teamsres(result: [Teams(team_name: "Team A", team_logo: "logo_url", team_key: 22, players: [])])
        MockNetworkGeneric.resultToReturn = expectedTeam

        let expectation = self.expectation(description: "Data Binding")
        viewModel.bindResultToViewController = {
            expectation.fulfill()
        }

        viewModel.loadData()
        waitForExpectations(timeout: 2)

        XCTAssertEqual(viewModel.result?.team_name, "Team A")
    }
}
