//
//  TeamsViewModelTests.swift
//  SportsWorldTests
//
//  Created by Sarah on 19/08/2024.
//

import XCTest
@testable import SportsWorld

final class TeamViewModelTests: XCTestCase {

    var viewModel: TeamsViewModel!
    var mockNetwork: MockNetwork!
    
    override func setUpWithError() throws {
        mockNetwork = MockNetwork(shouldReturnError: false)
        viewModel = TeamsViewModel()
        viewModel.network = mockNetwork as? any Networkprotocol
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockNetwork = nil
    }

    
    func testLoadDataSuccess() {
            let expectation = self.expectation(description: "Team data fetched and bound to view controller")

            viewModel.bindResultToViewController = {
                XCTAssertNotNil(self.viewModel.result)
                XCTAssertEqual(self.viewModel.result?.team_name, "Mock Team") 
                expectation.fulfill()
            }

            viewModel.loadData()
            waitForExpectations(timeout: 5)
        }
    }
