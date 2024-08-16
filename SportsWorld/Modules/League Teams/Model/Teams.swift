//
//  Teams.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 14/08/2024.
//

import Foundation

struct Teams: Codable {
    
    var team_name: String
    var team_logo: String
    var team_key: Int
    var players : [Players]
    
    
}
