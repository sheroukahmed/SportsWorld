//
//  SportsCollectionViewController.swift
//  SportsWorld
//
//  Created by Sarah on 13/08/2024.
//

import UIKit

private let reuseIdentifier = "Cell"

class SportsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let sports = ["football", "basketball", "cricket", "tennis"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: sports[indexPath.row].capitalized)
        
        (cell.viewWithTag(2) as! UILabel).text = sports[indexPath.row].capitalized
        
        cell.layer.cornerRadius = 50


        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.view.frame.width * 0.499, height: self.view.frame.width * 0.499)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            0.1
        }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let leagues = self.storyboard?.instantiateViewController(withIdentifier: "leagues") as! LeaguesViewController
        
        leagues.title = sports[indexPath.row].capitalized + " Leagues"
        leagues.sport = sports[indexPath.row]
        
        //self.present(leagues, animated: true)
        self.navigationController?.pushViewController(leagues, animated: true)
    }

}
