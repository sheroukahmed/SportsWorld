
//
//  LDViewModel.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 13/08/2024.
//

import Foundation


class LeagueDetailsViewModel {
    
    var network: Networkprotocol?
    var bindResultToViewController: (() -> Void) = {}
    var sport: String?
    var league: League?
    var leagueKey: Int?
    var coreDataManager: CoreDataManagerProtocol

    var leagueTeams: [hometeam] = []

    var upEvents: [Match]? {
        didSet {
            checkIfDataIsFetched()
        }
    }
    
    var lateEvents: [Match]? {
        didSet {
            checkIfDataIsFetched()
        }
    }
    
    
    init(sport:String? , leagueKey : Int?, league : League?) {
        self.sport = sport
        self.leagueKey = leagueKey
        self.league = league
        self.network = Network()
        self.coreDataManager = CoreDataManager.shared
    }
    

    func loadData() {
        let upcomingURL = URLManger.getFullURL(sport: sport ?? "", detail: "leagueEvents", leagueKey: leagueKey ?? 0, eventSelector: .upcoming) ?? ""
        let latestURL = URLManger.getFullURL(sport: sport ?? "", detail: "leagueEvents", leagueKey: leagueKey ?? 0, eventSelector: .latest) ?? ""

        network?.fetch(url: upcomingURL, type: Events.self, complitionHandler: { [weak self] upcoming in
            self?.upEvents = upcoming?.result
        })
        
        network?.fetch(url: latestURL, type: Events.self, complitionHandler: { [weak self] latest in
            self?.lateEvents = latest?.result
            for teams in self?.lateEvents ?? [] {
                self?.leagueTeams.append(hometeam(team_title: teams.event_home_team ?? "", team_logo: teams.home_team_logo ?? "", team_key: teams.home_team_key ?? 0))
            }
        })
    }
    
    
    private func checkIfDataIsFetched() {
        if upEvents != nil && lateEvents != nil {
            bindResultToViewController()
        }
    }
    
    
    func editInCoreData(league: League, leagueKey: Int, isFavourite: Bool, sport: String) {
        if isFavourite {
            coreDataManager.removeFromFavourites(leagueKey: leagueKey)
        } else {
            coreDataManager.addToFavourites(favLeague: league, sport: sport)
        }
    }

}
