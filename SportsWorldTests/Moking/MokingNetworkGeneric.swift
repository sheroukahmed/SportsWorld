//
//  MokingNetworkGeneric.swift
//  SportsWorldTests
//
//  Created by  sherouk ahmed  on 19/08/2024.
//

import XCTest

@testable import SportsWorld

class MockNetworkGeneric: Networkprotocol {
    var resultToReturn: Codable?
    var shouldReturnError = false

    func fetch<T: Codable>(url: String, type: T.Type, complitionHandler: @escaping (T?) -> Void) {
        if shouldReturnError {
            complitionHandler(nil)
        } else {
            complitionHandler(resultToReturn as? T)
        }
    }
}



