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

    init() {
        self.network = Network()
        self.coreDataManager = CoreDataManager()
    }

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

    func getUpEvents() -> [Match] {
        return upEvents ?? []
    }

    func getLateEvents() -> [Match] {
        return lateEvents ?? []
    }

    func loadData() {
        let upcomingURL = URLManger.getFullURL(sport: sport ?? "", detail: "leagueEvents", leagueKey: leagueKey ?? 0, eventSelector: .upcoming) ?? ""
        let latestURL = URLManger.getFullURL(sport: sport ?? "", detail: "leagueEvents", leagueKey: leagueKey ?? 0, eventSelector: .latest) ?? ""

        network?.fetch(url: upcomingURL, type: Events.self, complitionHandler: { [weak self] upcoming in
            self?.upEvents = upcoming?.result
        })

        network?.fetch(url: latestURL, type: Events.self, complitionHandler: { [weak self] latest in
            self?.lateEvents = latest?.result
        })
    }

    private func checkIfDataIsFetched() {
        if upEvents != nil && lateEvents != nil {
            print(upEvents)
            print(lateEvents)
            bindResultToViewController()
        }
    }
}









//import Foundation
//
//class LeagueDetailsViewModel{
//
//    var network: Network?
//    var bindResultToViewController : (()->()) = {}
//    var sport: String!
//    var leagueKey: Int!
//    var coreDataManager: CoreDataProtocol?
//
//
//    init(network : Network) {
//        self.network = network
//        self.coreDataManager = CoreDataManager()
//    }
//
//
//    var upEvents: [Match]? {
//        didSet{
//            bindResultToViewController()
//        }
//    }
//    var lateEvents: [Match]? {
//        didSet{
//            bindResultToViewController()
//        }
//    }
//
//    func getUpEvents()->[Match]{
//        return upEvents ?? []
//    }
//
//    func getLateEvents()->[Match]{
//        return lateEvents ?? []
//    }
//
//
//    func loadData(){
//
//        network?.fetch(url: URLManger.getFullURL(sport: "football", detail: "leagueEvents",leagueKey: 3,eventSelector: .upcoming) ?? "", type: Events.self, complitionHandler:{ [weak self] upcoming in
//            guard let self = self else { return }
//                if let upcomingEvents = upcoming?.result {
//                    print("Successfully fetched upcoming events.")
//                    self.upEvents = upcomingEvents
//                } else {
//                    print("No upcoming events found.")
//                }
//
//        })
//
//        network?.fetch(url: URLManger.getFullURL(sport: "football", detail: "leagueEvents",leagueKey: 3,eventSelector: .latest) ?? "", type: Events.self, complitionHandler:{ [weak self] latest in
//                self?.lateEvents = latest?.result
//        })
//
//    }
//
//
//
//}
