//
//  Match.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 13/08/2024.
//

import Foundation


struct Match: Codable {
    
    var event_home_team: String?
    var home_team_key: Int?
    
    var event_away_team: String?
    var away_team_key: Int?
    
    var home_team_logo: String?
    var away_team_logo: String?
    
    var event_date: String?
    var event_time: String?
    
    var event_final_result: String?
    
}
