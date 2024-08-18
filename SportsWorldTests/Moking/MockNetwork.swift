//
//  MockNetwork.swift
//  SportsWorldTests
//
//  Created by Sarah on 19/08/2024.
//

import XCTest
@testable import SportsWorld

class MockNetwork {
    
    var shouldReturnError: Bool
    
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    let fakeJSON: [String : Any] =
    [ "result" : [
        "league_key": 4,
        "league_name": "UEFA Europa League",
        "league_logo": "https://apiv2.allsportsapi.com/logo/logo_leagues/"
    ]
    ]
    
}

extension MockNetwork {
    func fetch(complitionHandler: @escaping (League?, Error?) -> Void) {
        
        var result = League()
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeJSON)
            result = try JSONDecoder().decode(League.self, from: data)
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        enum responseWithError: Error {
            case responseError
        }
        
        if shouldReturnError {
            //error
            complitionHandler (nil, responseWithError.responseError)
        } else {
            //data
            complitionHandler (result, nil)
        }
        
    }
}

