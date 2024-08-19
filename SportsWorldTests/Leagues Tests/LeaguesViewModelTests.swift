//
//  LeaguesViewModelTests.swift
//  SportsWorldTests
//
//  Created by Sarah on 19/08/2024.
//

import XCTest
@testable import SportsWorld

final class LeaguesViewModelTests: XCTestCase {

    var viewModel: LeaguesViewModel!
    var mockNetwork: MockNetwork!
    
    override func setUpWithError() throws {
        mockNetwork = MockNetwork(shouldReturnError: false)
        viewModel = LeaguesViewModel(sport: "football")
        viewModel.networkHandler = mockNetwork as? any Networkprotocol
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockNetwork = nil
    }

    func testLoadDataFromApiSuccess() {
           let expectation = self.expectation(description: "Data fetched and bound to view controller")
           
           viewModel.bindResultToViewController = {
               XCTAssertNotNil(self.viewModel.result)
               XCTAssertEqual(self.viewModel.result?.count, 3) 
               expectation.fulfill()
           }
           
           viewModel.loadDataFromApi()
           waitForExpectations(timeout: 5)
       }
    
    
   }
