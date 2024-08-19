//
//  FavoritesViewModel.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 17/08/2024.
//

import Foundation
import CoreData

class FavouritesViewModel {
    var sport :String?
    var coreDataManager: CoreDataManagerProtocol
    var bindResultToViewController : (()->()) = {}
    var result : [League]?  {
        didSet{
            bindResultToViewController()
        }
    }
    
    init() {
        coreDataManager = CoreDataManager.shared
    }
    
    func loadDatafromCoreData() {
        let storedFavourites = coreDataManager.getFavourites()
        self.result = []
        for fav in storedFavourites {
            var league = League()
            self.sport = fav.value(forKey: "sport") as? String
            league.league_name = fav.value(forKey: "league_name") as? String
            league.league_logo = fav.value(forKey: "league_logo") as? String
            league.league_key = fav.value(forKey: "league_key") as? Int
            self.result?.append(league)
        }
    }
    
    
    
   
    func removeFavourite(leagueKey: Int){
        coreDataManager.removeFromFavourites(leagueKey: leagueKey)
        
    }
    
}
