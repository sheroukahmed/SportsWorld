//
//  LeaguesTableViewCell.swift
//  SportsWorld
//
//  Created by Sarah on 16/08/2024.
//

import UIKit

class LeaguesTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueLogo: UIImageView!
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var youtubeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
/*
    func setCell(league: League) {
        
        if league.league_youtube!.isEmpty {
            youtubeButton.isHidden = true
        } else {
            youtubeButton.isHidden = false
        }
        
    }
 */
}
