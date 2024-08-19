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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didTapLongPress))
        longPressRecognizer.minimumPressDuration = 0.05
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
            // Scale the cell back to its original size and set full opacity
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1.0
        }, completion: nil)
        
        /*
         cell.alpha = 0
         UIView.animate(withDuration: 0.9, animations: {
         cell.alpha = 1
         })
        */
        
        /*
         cell.transform = CGAffineTransform(translationX: 0, y: collectionView.bounds.size.height)
         
         UIView.animate(withDuration: 1, delay: 0.05 * Double(indexPath.row), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
         // Reset the cell's position to its final location
         cell.transform = CGAffineTransform.identity
         }, completion: nil)
        */
        
        
        /*
         cell.layer.transform = CATransform3DMakeRotation(.pi / 2, 2, 2, 2)
         
         UIView.animate(withDuration: 1.0, delay: 0.05 * Double(indexPath.row), options: .curveEaseInOut, animations: {
         // Reset the cell's transform to its normal position
         cell.layer.transform = CATransform3DIdentity
         }, completion: nil)
         
         */
        
        /*
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
                bounceAnimation.values = [0, -10, 0, 10, 0]
                bounceAnimation.duration = 0.6
                bounceAnimation.repeatCount = .infinity
                bounceAnimation.autoreverses = true
                bounceAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                
                // Add the animation to the cell's layer
                cell.layer.add(bounceAnimation, forKey: "bounce")
    */
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func didTapLongPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        
        if sender.state == .began, let indexPath = indexPath, let cell = collectionView.cellForItem(at: indexPath) {
            // Initial press down, animate inward, keep track of the currently pressed index path
            
            animate(cell, to: pressedDownTransform)
            self.currentIndexPath = indexPath
        } else if sender.state == .changed {
            // Touch moved
            // If the touch moved outwidth the current cell, then animate the current cell back up
            // Otherwise, animate down again
            
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
            // Touch ended/cancelled, revert the cell to identity
            
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
        

