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
    var bindResultToViewController : (()->()) = {}
    var sport: String!
    var result : [League]?  {
        didSet{
            bindResultToViewController()
        }
    }
    
    init(sport : String) {
        self.sport = sport
        networkHandler = Network()
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
    


    
//    func loadDatafromCoreData() {
//        let storedFavourites = coreDataManager.getFavourites()
//
//        for fav in storedFavourites {
//            let league = League()
//            league.league_name = fav.value(forKey: "league_name") as? String
//            league.league_logo = fav.value(forKey: "league_logo") as? String
//            league.league_key = fav.value(forKey: "league_key") as? Int
//            self.favResult.append(league)
//        }
//    }
    
    
//    func removeFavourite(leagueKey: Int) {
//        coreDataManager.removeFromFavourites(leagueKey: leagueKey)
//
//    }
    
//    func loadData(isChecked: Bool) {
//        if isChecked {
//            loadDataFromApi()
//            bindResultToViewController()
//        } else {
//            loadDatafromCoreData()
//        }
        
  //  }
    
}
