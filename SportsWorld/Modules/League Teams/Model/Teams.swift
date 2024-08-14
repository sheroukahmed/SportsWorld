//
//  Teams.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 14/08/2024.
//

import Foundation

struct Teams: Codable, Hashable {
    var team_title: String
    var team_logo: String
    var team_key: Int
    
    init(team_title: String, team_logo: String, team_key: Int) {
        self.team_title = team_title
        self.team_logo = team_logo
        self.team_key = team_key
    }
}
