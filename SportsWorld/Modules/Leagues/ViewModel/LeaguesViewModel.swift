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
    var coreDataManager: CoreDataProtocol?
    var bindResultToViewController : (()->()) = {}
    var sport: String!
    var favResult : [NSManagedObject]?
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

    
    func loadDatafromCoreData(){
        coreDataManager?.fetchFromCoreData()
        favResult = coreDataManager!.getStoredData()
        
    }
    
    func convertToLeague(nsLeague: NSManagedObject) -> League{
        let league = League()
        league.league_name = (nsLeague.value(forKey: "league_name") as! String)
        league.league_logo = (nsLeague.value(forKey: "league_logo") as! String)
        league.league_key = (nsLeague.value(forKey: "league_key") as! Int)
        return league
    }
    
    func removeFavourite(leagueKey: Int, sport: String){
        coreDataManager?.deleteFromCoreData(leagueKey: leagueKey, sport: sport)
        
    }
    
    func getFavouriteLeagues() -> [NSManagedObject]{
        return favResult ?? []
    }
    
    func getLeagues()->[League]{
        return result ?? []
    }
    
    
}
