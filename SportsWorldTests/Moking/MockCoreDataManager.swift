//
//  MockCoreDataManager.swift
//  SportsWorldTests
//
//  Created by Sarah on 19/08/2024.
//

import XCTest
import CoreData
@testable import SportsWorld

class MockFavourite: NSManagedObject {
    @objc var league_key: NSNumber?
    @objc var league_name: NSString?
    @objc var league_logo: NSString?
    @objc var sport: NSString?
}

class MockCoreDataManager: CoreDataManagerProtocol {
    var favourites: [MockFavourite] = []
    var shouldReturnError = false

    func getFavourites() -> [NSManagedObject] {
        return favourites
    }

    func addToFavourites(favLeague: League, sport: String) {
        let favourite = MockFavourite()
                favourite.league_key = favLeague.league_key as NSNumber?
                favourite.league_name = favLeague.league_name as NSString?
                favourite.league_logo = favLeague.league_logo as NSString?
                favourite.sport = sport as NSString?
                favourites.append(favourite)
    }

    func removeFromFavourites(leagueKey: Int) {
        favourites.removeAll { $0.league_key == leagueKey as NSNumber }
    }

    func isFavourited(leagueKey: Int) -> Bool {
        return favourites.contains { $0.league_key == leagueKey as NSNumber }
    }
}
