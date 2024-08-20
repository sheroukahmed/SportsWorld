//
//  CoredataTest.swift
//  SportsWorldTests
//
//  Created by  sherouk ahmed  on 20/08/2024.
//


import XCTest
import CoreData
@testable import SportsWorld

class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var mockPersistentContainer: NSPersistentContainer!
    
    override func setUpWithError() throws {
        
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        mockPersistentContainer = NSPersistentContainer(name: "SportsWorld", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        mockPersistentContainer.persistentStoreDescriptions = [description]
        
        mockPersistentContainer.loadPersistentStores { (description, error) in
            XCTAssertNil(error)
        }
        
        coreDataManager = CoreDataManager.shared
        coreDataManager.setContext(mockPersistentContainer.viewContext)
    }


    
    override func tearDown() {
        coreDataManager = nil
        mockPersistentContainer = nil
        super.tearDown()
    }
    
    func testAddToFavourites() {
        let league = League(league_key: 1, league_name: "Premier League", league_logo: "https://someurl.com/logo.png")
        
        coreDataManager.addToFavourites(favLeague: league, sport: "Football")
        
        let favourites = coreDataManager.getFavourites()
        
        XCTAssertEqual(favourites.count, 1)
        XCTAssertEqual(favourites.first?.value(forKey: "league_name") as? String, "Premier League")
    }
    
    func testRemoveFromFavourites() {
        let league = League(league_key: 1, league_name: "Premier League", league_logo: "https://someurl.com/logo.png")
        
        coreDataManager.addToFavourites(favLeague: league, sport: "Football")
        coreDataManager.removeFromFavourites(leagueKey: 1)
        
        let favourites = coreDataManager.getFavourites()
        
        XCTAssertEqual(favourites.count, 0)
    }
    
    func testIsFavourited() {
        let league = League(league_key: 1, league_name: "Premier League", league_logo: "https://someurl.com/logo.png")
        
        coreDataManager.addToFavourites(favLeague: league, sport: "Football")
        
        let isFavourite = coreDataManager.isFavourited(leagueKey: 1)
        XCTAssertTrue(isFavourite)
        
        coreDataManager.removeFromFavourites(leagueKey: 1)
        
        let isNotFavourite = coreDataManager.isFavourited(leagueKey: 1)
        XCTAssertFalse(isNotFavourite)
    }
    
    func testGetFavourites() throws {
        let league1 = League(league_key: 4, league_name: "UEFA Europa League", league_logo: nil)
        let league2 = League(league_key: 5, league_name: "Premier League", league_logo: nil)
        
        coreDataManager.addToFavourites(favLeague: league1, sport: "football")
        coreDataManager.addToFavourites(favLeague: league2, sport: "football")
        
        let favourites = coreDataManager.getFavourites()
        
        XCTAssertEqual(favourites.count, 2, "There should be exactly two favourites stored.")
    }
    
    func testAddToFavouritesWithInvalidData() throws {
        let league = League(league_key: nil, league_name: nil, league_logo: nil)
        coreDataManager.addToFavourites(favLeague: league, sport: "")
        
        let favourites = coreDataManager.getFavourites()
        
        XCTAssertEqual(favourites.count, 1, "Even with invalid data, one favourite should be added.")
        XCTAssertEqual(favourites.first?.value(forKey: "league_name") as? String, "", "Stored league name should be empty.")
        XCTAssertEqual(favourites.first?.value(forKey: "sport") as? String, "", "Stored sport should be empty.")
    }
    
    func testRemoveNonExistentFavourite() throws {
        coreDataManager.removeFromFavourites(leagueKey: 9999)
        
        let favourites = coreDataManager.getFavourites()
        
        XCTAssertEqual(favourites.count, 0, "Removing a non-existent favourite should not affect the count.")
    }






}
