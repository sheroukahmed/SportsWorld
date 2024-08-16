
//
//  LDViewModel.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 13/08/2024.
//



class LeagueDetailsViewModel {
    var network: Networkprotocol?
    var bindResultToViewController: (() -> Void) = {}
    var sport: String?
    var leagueKey: Int?
    var coreDataManager: CoreDataProtocol?

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
    
    init() {
        self.network = Network()
        self.coreDataManager = CoreDataManager.shared
    }

    func loadData() {
        let upcomingURL = URLManger.getFullURL(sport: sport ?? "", detail: "leagueEvents", leagueKey: leagueKey ?? 0, eventSelector: .upcoming) ?? ""
        let latestURL = URLManger.getFullURL(sport: sport ?? "", detail: "leagueEvents", leagueKey: leagueKey ?? 0, eventSelector: .latest) ?? ""
        let teamURL = URLManger.getFullURL(sport: sport ?? "", detail: "team", leagueKey: leagueKey ?? 0 , eventSelector: .latest) ?? ""

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
    
    func editInCoreData(league: League, sport: String, favourite: Bool) {
        if favourite {
            coreDataManager?.insertIntoCoreData(favLeague: league, sport: sport)
        } else {
            coreDataManager?.deleteFromCoreData(leagueKey: (league.league_key)!, sport: sport)
        }
    }
}
