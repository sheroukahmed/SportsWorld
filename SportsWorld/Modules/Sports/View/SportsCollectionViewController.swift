//
//  SportsCollectionViewController.swift
//  SportsWorld
//
//  Created by Sarah on 13/08/2024.
//

import UIKit
import Alamofire

private let reuseIdentifier = "Cell"

class SportsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    let sports = ["football", "basketball", "cricket", "tennis"]
    
    var currentIndexPath: IndexPath?
    let pressedDownTransform =  CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didTapLongPress))
        longPressRecognizer.minimumPressDuration = 0.0000001
        longPressRecognizer.cancelsTouchesInView = false
        longPressRecognizer.delegate = self
        collectionView.addGestureRecognizer(longPressRecognizer)
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
        if NetworkReachabilityManager()?.isReachable ?? false {
            let leagues = self.storyboard?.instantiateViewController(withIdentifier: "leagues") as! LeaguesViewController
            
            leagues.title = sports[indexPath.row].capitalized + " Leagues"
            leagues.leaguesViewModel = LeaguesViewModel(sport: sports[indexPath.row])
            leagues.listAllLeagues = true
            
            self.navigationController?.pushViewController(leagues, animated: true)
        } else {
            let alert = UIAlertController(title: "No Internet Connection!", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        cell.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        cell.alpha = 0.2
        
        
        UIView.animate(withDuration: 1.1, delay: 0.05 * Double(indexPath.row), options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1.0
        }, completion: nil)
        
    }
    
    // Animation

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func didTapLongPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        
        if sender.state == .began, let indexPath = indexPath, let cell = collectionView.cellForItem(at: indexPath) {
            animate(cell, to: pressedDownTransform)
            self.currentIndexPath = indexPath
        } else if sender.state == .changed {
            if indexPath != self.currentIndexPath, let currentIndexPath = self.currentIndexPath, let cell = collectionView.cellForItem(at: currentIndexPath) {
                if cell.transform != .identity {
                    animate(cell, to: .identity)
                }
            } else if indexPath == self.currentIndexPath, let indexPath = indexPath, let cell = collectionView.cellForItem(at: indexPath) {
                if cell.transform != pressedDownTransform {
                    animate(cell, to: pressedDownTransform)
                }
            }
        } else if let currentIndexPath = currentIndexPath, let cell = collectionView.cellForItem(at: currentIndexPath) {
            
            animate(cell, to: .identity)
            self.currentIndexPath = nil
        }
    }
    
    private func animate(_ cell: UICollectionViewCell, to transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
            cell.transform = transform
        }, completion: nil)
    }
    
}
        

