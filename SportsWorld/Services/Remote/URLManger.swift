//
//  URLManger.swift
//  SportsApp
//
//  Created by  sherouk ahmed  on 12/08/2024.
//

import Foundation


class URLManger {
    
    static let base = "https://apiv2.allsportsapi.com/"
    static let constantKey = "f9711946902cdb48dff17c3fbad39cf22645dcf8d8fc79e58b23a508660c3a8c"
    static let allLeagues = "/?met=Leagues"
    static let leagueEvents = "?met=Fixtures&leagueId="
    static let team = "/?&met=Teams&teamId="
    static let from = "&from="
    static let to = "&to="
    static let key = "&APIkey="
    
    
    
    class func getDateOf(targetDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let year: TimeInterval = 365 * 24 * 60 * 60
        
        switch targetDate {
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
    
    
    class func getLeagueEventsURL(for sport: String, leagueKey: Int, eventSelector: EventsSelector) -> String? {
        let dateRange: String
        switch eventSelector {
        case .latest:
            dateRange = from + getDateOf(targetDate: "lastYear") + to + getDateOf(targetDate: "currentYear")
        case .upcoming:
            dateRange = from + getDateOf(targetDate: "currentYear") + to + getDateOf(targetDate: "nextYear")
        }
        return base + sport + leagueEvents + String(leagueKey) + dateRange + key + constantKey
    }
    
    
    class func getTeamURL(for sport: String, teamKey: Int) -> String? {
        return base + sport + team + String(teamKey) + key + constantKey
    }
    
    
    class func getAllLeaguesURL(for sport: String) -> String? {
        return base + sport + allLeagues + key + constantKey
    }
    
    
    
    
    class func getFullURL(sport: String, detail: String, leagueKey: Int = 0, eventSelector: EventsSelector = .upcoming, teamKey: Int = 0) -> String? {
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
