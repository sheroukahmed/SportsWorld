//
//  MockCoreDataManager.swift
//  SportsWorldTests
//
//  Created by Sarah on 19/08/2024.
//

import XCTest
import CoreData
@testable import SportsWorld


final class MockCoreDataManager: CoreDataManagerProtocol {
    
    var mockFavourites: [NSManagedObject] = []
    var isFavouritedResult: Bool = false
    
    func getFavourites() -> [NSManagedObject] {
        return mockFavourites
    }
    
    func addToFavourites(favLeague: League, sport: String) {
        let league = NSManagedObject()
        league.setValue(favLeague.league_key, forKey: "league_key")
        league.setValue(favLeague.league_name, forKey: "league_name")
        league.setValue(favLeague.league_logo, forKey: "league_logo")
        mockFavourites.append(league)
    }
    
    func removeFromFavourites(leagueKey: Int) {
        mockFavourites.removeAll { $0.value(forKey: "league_key") as? Int == leagueKey }
    }
    
    func isFavourited(leagueKey: Int) -> Bool {
        return isFavouritedResult
    }
}
