//
//  LeagueDetailsViewModelTests.swift
//  SportsWorldTests
//
//  Created by Sarah on 19/08/2024.
//

import XCTest
@testable import SportsWorld

final class LeaguesDetailsViewModelTests: XCTestCase {
    
    var viewModel: LeagueDetailsViewModel!
    var mockNetwork: MockNetwork!
    
    
    override func setUpWithError() throws {
        mockNetwork = MockNetwork(shouldReturnError: false)
        viewModel = LeagueDetailsViewModel(sport: "football", leagueKey: 4, league: League())
        viewModel.network = mockNetwork as? any Networkprotocol
    }
    
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockNetwork = nil
    }

    
    func testLoadDataSuccess() {
          let expectation = self.expectation(description: "Upcoming and Latest events fetched and bound to view controller")

          viewModel.bindResultToViewController = {
              XCTAssertNotNil(self.viewModel.upEvents)
              XCTAssertNotNil(self.viewModel.lateEvents)
              expectation.fulfill()
          }

          viewModel.loadData()
          waitForExpectations(timeout: 5)
      }
  }
