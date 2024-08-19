//
//  LeaguesViewModelTests.swift
//  SportsWorldTests
//
//  Created by Sarah on 19/08/2024.
//

import XCTest
@testable import SportsWorld


class LeaguesViewModelTests: XCTestCase {
    var viewModel: LeaguesViewModel!
    var MockNetworkGeneric: MockNetworkGeneric!

    override func setUp() {
        super.setUp()
        MockNetworkGeneric = SportsWorldTests.MockNetworkGeneric()
        viewModel = LeaguesViewModel(sport: "football")
        viewModel.networkHandler = MockNetworkGeneric
        MockNetworkGeneric.resultToReturn = Leagues.self as? any Codable
    }

    override func tearDown() {
        viewModel = nil
        MockNetworkGeneric = nil
        super.tearDown()
    }

    func testLoadDataFromApiSuccess() {
        
        let expectedLeagues = Leagues(result: [League (league_key: 1, league_name: "Premier League", league_logo: "logo_url")])
        MockNetworkGeneric.resultToReturn = expectedLeagues
        

        let expectation = self.expectation(description: "Data Binding")
        viewModel.bindResultToViewController = {
            expectation.fulfill()
        }

        viewModel.loadDataFromApi()
        waitForExpectations(timeout: 2)

        XCTAssertEqual(viewModel.result?.first?.league_name, "Premier League")
    }

    func testLoadDataFromApiFailure() {
        MockNetworkGeneric.shouldReturnError = true

        let expectation = self.expectation(description: "Data Binding")
        viewModel.bindResultToViewController = {
            print("bindResultToViewController called")
            expectation.fulfill()
        }

        viewModel.loadDataFromApi()
        waitForExpectations(timeout: 5)

        XCTAssertNil(viewModel.result)
    }
}














//final class LeaguesViewModelTests: XCTestCase {
//
//    var viewModel: LeaguesViewModel!
//    var mockNetwork: MockNetwork!
//
//    override func setUpWithError() throws {
//        mockNetwork = MockNetwork(shouldReturnError: false)
//        viewModel = LeaguesViewModel(sport: "football")
//        viewModel.networkHandler = mockNetwork as? any Networkprotocol
//    }
//
//    override func tearDownWithError() throws {
//        viewModel = nil
//        mockNetwork = nil
//    }
//
//    func testLoadDataFromApiSuccess() {
//           let expectation = self.expectation(description: "Data fetched and bound to view controller")
//
//        let mockNetwork = MockNetwork(shouldReturnError: false)
//        viewModel.networkHandler = mockNetwork as? any Networkprotocol
//           viewModel.bindResultToViewController = {
//               XCTAssertNotNil(self.viewModel.result)
//               XCTAssertEqual(self.viewModel.result?.count, 3)
//               expectation.fulfill()
//           }
//
//           viewModel.loadDataFromApi()
//           waitForExpectations(timeout: 7)
//       }
//
//
//   }
