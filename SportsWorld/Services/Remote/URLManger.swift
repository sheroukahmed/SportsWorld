//
//  URLManger.swift
//  SportsApp
//
//  Created by  sherouk ahmed  on 12/08/2024.
//

import Foundation

class URLManger {
    
    let base = "https://apiv2.allsportsapi.com/"
    let constantKey = "f9711946902cdb48dff17c3fbad39cf22645dcf8d8fc79e58b23a508660c3a8c"
    let allLeagues = "/?met=Leagues"
    let leagueEvents = "?met=Fixtures&leagueId="
    let team = "/?&met=Teams&teamId="
    let from = "&from="
    let to = "&to="
    let key = "&APIkey="

    
     func getDateOf(Targetdate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let year: TimeInterval = 365 * 24 * 60 * 60
        
        switch Targetdate {
        case "currentYear":
            return dateFormatter.string(from: Date())
        case "lastYear":
            return dateFormatter.string(from: Date().addingTimeInterval(-year))
        case "nextYear":
            return dateFormatter.string(from: Date().addingTimeInterval(year))
        default:
            return dateFormatter.string(from: Date())
        }
    }
    
    enum EventsSelector {
        case upcoming, latest
    }
    
     func getLeagueEventsURL(for sport: String, leagueKey: Int, eventSelector: EventsSelector) -> String {
        let dateRange: String
        switch eventSelector {
        case .latest:
            dateRange = from + getDateOf(Targetdate: "lastYear") + to + getDateOf(Targetdate: "currentYear")
        case .upcoming:
            dateRange = from + getDateOf(Targetdate: "currentYear") + to + getDateOf(Targetdate: "nextYear")
        }
        return base + sport + leagueEvents + String(leagueKey) + dateRange + key + constantKey
    }
    
     func getTeamURL(for sport: String, teamKey: Int) -> String {
        return base + sport + team + String(teamKey) + key + constantKey
    }
    
      func getAllLeaguesURL(for sport: String) -> String {
        return base + sport + allLeagues + key + constantKey
    }
    
      func getFullURL(sport: String, detail: String, leagueKey: Int = 0, eventSelector: EventsSelector = .upcoming, teamKey: Int = 0) -> String {
        switch detail {
        case "allLeagues":
            return getAllLeaguesURL(for: sport)
        case "leagueEvents":
            return getLeagueEventsURL(for: sport, leagueKey: leagueKey, eventSelector: eventSelector)
        case "team":
            return getTeamURL(for: sport, teamKey: teamKey)
        default:
            return getAllLeaguesURL(for: sport)
        }
    }
}
