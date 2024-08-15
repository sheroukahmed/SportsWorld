//
//  LeaguesViewModel.swift
//  SportsWorld
//
//  Created by Sarah on 14/08/2024.
//

import Foundation

class LeaguesViewModel {
    
    var networkHandler: Networkprotocol?
    var coreDataManager: CoreDataProtocol?
    var bindResultToViewController : (()->()) = {}
    var sport: String!
    var result : [League]?  {
        didSet{
            bindResultToViewController()
        }
    }
    
    init() {
        networkHandler = Network()
        coreDataManager = CoreDataManager()
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
        
    }
    
    func getLeagues()->[League]{
        return result ?? []
    }
    
    
}
