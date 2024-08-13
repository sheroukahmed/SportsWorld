//
//  LDViewModel.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 13/08/2024.
//

import Foundation

class LeagueDetailsViewModel{
    
    var network: Networkprotocol?
    var urlm: URLManger?
    var bindResultToViewController : (()->()) = {}
    var sport: String!
    var leagueKey: Int!
    var coreDataManager: CoreDataProtocol?
    
    
    init() {
        self.network = Network()
        self.urlm = URLManger()
        self.coreDataManager = CoreDataManager()
    }
    
    
    var upEvents: [Match]? {
        didSet{
            bindResultToViewController()
        }
    }
    var lateEvents: [Match]? {
        didSet{
            bindResultToViewController()
        }
    }
    
    func getUpEvents()->[Match]{
        return upEvents ?? []
    }
    
    func getLateEvents()->[Match]{
        return lateEvents ?? []
    }
    
    
    func loadData(){
        
        network?.fetch(url: urlm?.getFullURL(sport: sport, detail: "leagueEvents",leagueKey: leagueKey,eventSelector: .upcoming) ?? "", type: Events.self, complitionHandler:{ [weak self] upcoming in
            DispatchQueue.main.async {
                
                self?.upEvents = upcoming?.result
                
            }
        })
        
        network?.fetch(url: urlm?.getFullURL(sport: sport, detail: "leagueEvents",leagueKey: leagueKey,eventSelector: .latest) ?? "", type: Events.self, complitionHandler:{ [weak self] latest in
            DispatchQueue.main.async {
                
                self?.lateEvents = latest?.result
            }
        })
            
    }
    

    
}
