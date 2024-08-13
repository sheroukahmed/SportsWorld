//
//  CoreDataManager.swift
//  SportsWorld
//
//  Created by Sarah on 13/08/2024.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataProtocol{
    
    func fetchFromCoreData()
    func insertIntoCoreData(favLeague: League, sport: String)
    func deleteFromCoreData(leagueKey: Int, sport: String)
    func getStoredData() -> [NSManagedObject]
    
}


class CoreDataManager: CoreDataProtocol {
 
    var context : NSManagedObjectContext!
    var storedData: [NSManagedObject]?
    var dummyLeagueLogo = "https://static.vecteezy.com/system/resources/previews/029/885/532/non_2x/trophy-icon-illustration-champion-cup-logo-vector.jpg"
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        context = delegate.persistentContainer.viewContext
    }
    
    
    func fetchFromCoreData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeagues")
        
        do {
            storedData = try context.fetch(fetchRequest)
            if storedData?.count == 0 {
                print("Not data to present")
            }

        } catch let error{
            print("Can't Fetch")
            print(error.localizedDescription)
        }
    }
    
    func insertIntoCoreData(favLeague: League, sport: String) {
        let leaguesEntity = NSEntityDescription.entity(forEntityName: "FavouriteLeagues", in: context)
        
        let league = NSManagedObject(entity: leaguesEntity!, insertInto: context)
        league.setValue(favLeague.league_key ?? 0, forKey: "league_key")
        if let league_logo = favLeague.league_logo {
            league.setValue(league_logo.last == "/" ? dummyLeagueLogo : league_logo, forKey: "league_logo")
        }
        league.setValue(favLeague.league_name ?? "", forKey: "league_name")
        league.setValue(sport , forKey: "sport")
        league.setValue(favLeague.league_youtube , forKey: "league_youtube")
        do {
            try context.save()
            print("Saved!!")
        } catch let error {
            print("Not Saved!\n")
            print(error.localizedDescription)
        }
    }


    func deleteFromCoreData(leagueKey: Int, sport: String) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeagues")
        fetchRequest.predicate = NSPredicate(format: "league_key == %d", leagueKey)
        
        do {
            let leagues = try context.fetch(fetchRequest)
            print(leagues.count)
            if leagues.count > 0 {
                context.delete(leagues[0])
                try context.save()
                print("Deleted!!")
            }
        } catch let error as NSError {
            print("Can't Delete a League!")
            print(error.localizedDescription)
        }
    }
    
    
    func getStoredData() -> [NSManagedObject] {
        return storedData ?? []
    }
    
}
