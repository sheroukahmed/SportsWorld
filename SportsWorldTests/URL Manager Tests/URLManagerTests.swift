//
//  URLManagerTests.swift
//  SportsWorldTests
//
//  Created by Sarah on 19/08/2024.
//

import XCTest
@testable import SportsWorld

final class URLManagerTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {

    }

    func testGetAllLeaguesURL() {
            let url = URLManger.getAllLeaguesURL(for: "football")
            let expectedURL = "https://apiv2.allsportsapi.com/football/?met=Leagues&APIkey=f9711946902cdb48dff17c3fbad39cf22645dcf8d8fc79e58b23a508660c3a8c"
            XCTAssertEqual(url, expectedURL, "The all leagues URL is incorrect")
        }
    

        func testGetLeagueEventsURL() {
            // Expected URL must be Changed according to today's date 
            let url = URLManger.getLeagueEventsURL(for: "football", leagueKey: 123, eventSelector: .upcoming)
       
            let expectedURL = "https://apiv2.allsportsapi.com/football?met=Fixtures&leagueId=123&from=2024-08-20&to=2025-08-20&APIkey=f9711946902cdb48dff17c3fbad39cf22645dcf8d8fc79e58b23a508660c3a8c"
            XCTAssertEqual(url, expectedURL, "The league events URL is incorrect")
        }

    
        func testGetTeamURL() {
            let url = URLManger.getTeamURL(for: "football", teamKey: 456)
            let expectedURL = "https://apiv2.allsportsapi.com/football/?&met=Teams&teamId=456&APIkey=f9711946902cdb48dff17c3fbad39cf22645dcf8d8fc79e58b23a508660c3a8c"
            XCTAssertEqual(url, expectedURL, "The team URL is incorrect")
        }
    }
