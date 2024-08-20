//
//  TeamsViewModel.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 14/08/2024.
//

import Foundation


class TeamsViewModel {
    
    var network: Networkprotocol?
    var bindResultToViewController : (()->()) = {}
    var sport: String?
    var teamKey: Int?
    var result : Teams?  {
        didSet{
            bindResultToViewController()
        }
    }
    
    init() {
        self.network = Network()
    }
    
    
    func loadData(){
        
        let url = URLManger.getFullURL(sport: sport ?? "", detail: "team", teamKey: teamKey ?? 0) ?? ""
        print(url)
        network?.fetch(url: url, type: Teamsres.self, complitionHandler: { team in
            self.result = team?.result?[0]
        })
    }
    
}
