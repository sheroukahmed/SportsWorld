//
//  LeaguesViewModel.swift
//  SportsWorld
//
//  Created by Sarah on 14/08/2024.
//

import Foundation
import CoreData

class LeaguesViewModel {
    
    var networkHandler: Networkprotocol?
    var coreDataManager: CoreDataManager
    var bindResultToViewController : (()->()) = {}
    var sport: String!
    var favResult = [League]()
    var result : [League]?  {
        didSet{
            bindResultToViewController()
        }
    }
    
    init() {
        networkHandler = Network()
        coreDataManager = CoreDataManager.shared
    }
    
    func loadDataFromApi(){
        networkHandler?.fetch(url: URLManger.getFullURL(sport: sport, detail: "allLeagues") ?? "" , type: Leagues.self, complitionHandler: { [weak self] leagues in
            guard let self = self else { return }
            if let leagues = leagues {
                self.result = leagues.result
            } else {
                print("Failed to fetch or decode leagues")
            }
        })
    }

    
    func loadDatafromCoreData() -> [League] {
        let storedFavourites = coreDataManager.getFavourites()
        
        for fav in storedFavourites {
            let league = League()
            league.league_name = fav.value(forKey: "league_name") as? String
            league.league_logo = fav.value(forKey: "league_logo") as? String
            league.league_key = fav.value(forKey: "league_key") as? Int
            self.favResult.append(league)
        }
        return favResult
    }
    
    
    func removeFavourite(leagueKey: Int) {
        coreDataManager.removeFromFavourites(leagueKey: leagueKey)

    }

    
    func getLeagues() -> [League] {
        return result ?? []
    }
    
    
}
