//
//  NetworkTests.swift
//  SportsWorldTests
//
//  Created by Sarah on 18/08/2024.
//

import XCTest
@testable import SportsWorld

final class NetworkTests: XCTestCase {
    
    var network: Network!
    var mockObj: MockNetwork!

    override func setUpWithError() throws {
        network = Network()
    }
    
    override func tearDownWithError() throws {
        network = nil
        mockObj = nil
    }
    
    func testfetchDataSuccess() {
        
        let myExpectatin = self.expectation(description: "Fetching data from API...")
        
        let url = "https://apiv2.allsportsapi.com/football/?met=Leagues&APIkey=f9711946902cdb48dff17c3fbad39cf22645dcf8d8fc79e58b23a508660c3a8c"
        
        network.fetch(url: url, type: Leagues.self) { result in
            
            XCTAssertNotNil(result, "Expected non-nil result")
            print("Result: \(String(describing: result))")
            if let league = result?.result?.first {
                XCTAssertEqual(league.league_key, 4)
                XCTAssertEqual(league.league_name, "UEFA Europa League")
            } else {
                XCTFail("Expected a valid league in the result")
            }
            
                myExpectatin.fulfill()
            }
        
        waitForExpectations(timeout: 5)
    }
    
    func testfetchDataFailure() {
        
        let myExpectatin = self.expectation(description: "Fetching data from API...")
        
        let url = "https://invalidURL"
        
        network.fetch(url: url, type: League.self) { result in
            
            XCTAssertNil(result, "Expected nil result for invalid url")
            myExpectatin.fulfill()
            }
        
        waitForExpectations(timeout: 7)
    }
    
    func testFetchMockData() {
        
        mockObj = MockNetwork(shouldReturnError: false)

        mockObj.fetch{ result, error in
            
            if error != nil {
                XCTFail()
            } else {
                XCTAssertNotNil(result)
            }
        }
    }
    
    
}
