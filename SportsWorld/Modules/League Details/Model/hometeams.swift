//
//  hometeams.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 16/08/2024.
//

import Foundation
struct hometeam :Codable{
    
    var event_home_team: String?
    var home_team_logo: String?
    var home_team_key: Int?
    
    init(team_title: String, team_logo: String, team_key: Int) {
        self.event_home_team = team_title
        self.home_team_logo = team_logo
        self.home_team_key = team_key
    }
    
}
