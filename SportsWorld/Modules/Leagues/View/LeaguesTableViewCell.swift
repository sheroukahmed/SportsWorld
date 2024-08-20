//
//  LeaguesTableViewCell.swift
//  SportsWorld
//
//  Created by Sarah on 18/08/2024.
//

import UIKit


class LeaguesTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueLogo: UIImageView!
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var youtubeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
