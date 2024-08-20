//
//  PlayersTableViewCell.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 14/08/2024.
//

import UIKit

class PlayersTableViewCell: UITableViewCell {

    @IBOutlet weak var playerpositionlabel: UILabel!
    @IBOutlet weak var playernolabel: UILabel!
    @IBOutlet weak var playernamelabel: UILabel!
    @IBOutlet weak var playerimage: UIImageView!
    @IBOutlet weak var backimage: UIImageView!
    @IBOutlet weak var content: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        playerimage.backgroundColor = .white
        content.layer.cornerRadius = 20

    }

}
