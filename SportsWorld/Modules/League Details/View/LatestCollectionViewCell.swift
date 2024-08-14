//
//  LatestCollectionViewCell.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 14/08/2024.
//

import UIKit

class LatestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hometeamlogo: UIImageView!
    
    @IBOutlet weak var awayteamlogo: UIImageView!
    
   
    @IBOutlet weak var hometeamlabel: UILabel!
    @IBOutlet weak var leaguematchlabel: UILabel!
    
    @IBOutlet weak var awayteamlabel: UILabel!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var scorelabel: UILabel!
}
