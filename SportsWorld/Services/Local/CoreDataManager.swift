//
//  CoreDataManager.swift
//  SportsWorld
//
//  Created by Sarah on 13/08/2024.
//

import UIKit
import CoreData

protocol CoreDataManagerProtocol {
    func getFavourites() -> [NSManagedObject]
    func addToFavourites(favLeague: League, sport: String)
    func removeFromFavourites(leagueKey: Int)
    func isFavourited(leagueKey: Int) -> Bool
}


class CoreDataManager: CoreDataManagerProtocol {
    
    var context : NSManagedObjectContext!
    var storedFavourites: [NSManagedObject]?
    var dummyLeagueLogo = "https://static.vecteezy.com/system/resources/previews/029/885/532/non_2x/trophy-icon-illustration-champion-cup-logo-vector.jpg"
    
    static let shared = CoreDataManager()
    
    private init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    func getFavourites() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeagues")
        do {
            storedFavourites = try context.fetch(fetchRequest)
            if storedFavourites?.count == 0 {
                print("Not data to present")
            }
        } catch let error{
            print("Can't Fetch")
            print(error.localizedDescription)
        }
        return storedFavourites ?? []
    }
    
    
    
    func addToFavourites(favLeague: League, sport: String) {
        let leaguesEntity = NSEntityDescription.entity(forEntityName: "FavouriteLeagues", in: context)
        let league = NSManagedObject(entity: leaguesEntity!, insertInto: context)
        
        league.setValue(favLeague.league_key ?? 0, forKey: "league_key")
        if let league_logo = favLeague.league_logo {
            league.setValue(league_logo.last == "/" ? dummyLeagueLogo : league_logo, forKey: "league_logo")
        }
        league.setValue(favLeague.league_name ?? "", forKey: "league_name")
        league.setValue(sport , forKey: "sport")
        do {
            try context.save()
            print("Saved!!")
        } catch let error {
            print("Not Saved!\n")
            print(error.localizedDescription)
        }
    }
    
    func removeFromFavourites(leagueKey: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeagues")
        let storedFavourites = try? self.context.fetch(fetchRequest)
        
        guard let favourites = storedFavourites else {
            return
        }
        for league in favourites {
            if league.value(forKey: "league_key") as! Int == leagueKey {
                context.delete(league)
            }
        }
            do {
                try context.save()
                print("Deleted!!")
            } catch let error as NSError {
                print("Can't Delete a League!")
                print(error.localizedDescription)
            }
        }
    
    func isFavourited(leagueKey: Int ) -> Bool{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteLeagues")
        fetchRequest.predicate = NSPredicate(format: "league_key == %d", leagueKey)
        
        do {
            let favourites = try self.context.fetch(fetchRequest)
            return !favourites.isEmpty
           } catch {
               print("Failed to fetch favourites: \(error.localizedDescription)")
               return false
           }
       }
}
