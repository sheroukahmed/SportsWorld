//
//  LeaguesViewController.swift
//  SportsWorld
//
//  Created by Sarah on 15/08/2024.
//

import UIKit
import Kingfisher
import Alamofire
import CoreData


class LeaguesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noFavouriteImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var favtitle: UILabel!
    
    var listAllLeagues = false
    var leaguesViewModel: LeaguesViewModel?
    var favoritesViewModel = FavouritesViewModel()
    var indicator: UIActivityIndicatorView?
    
    var dummyLeagueLogo = "https://static.vecteezy.com/system/resources/previews/029/885/532/non_2x/trophy-icon-illustration-champion-cup-logo-vector.jpg"
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        if listAllLeagues {
            
            favtitle.isHidden = true
            
            leaguesViewModel?.bindResultToViewController = { [weak self] in
                self?.tableView.reloadData()
            }
            leaguesViewModel?.loadDataFromApi()
        } else {
            favoritesViewModel = FavouritesViewModel()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !listAllLeagues{
            favoritesViewModel.result = []
            self.favtitle.text = "Favorites"
            self.favoritesViewModel.loadDatafromCoreData()
            favoritesViewModel.bindResultToViewController = {
                self.tableView.reloadData()
            }
            
            if self.favoritesViewModel.result?.count == 0 {
                self.noFavouriteImage.isHidden = false
                self.tableView.isHidden = true
            } else {
                self.noFavouriteImage.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
            tableView.reloadData()
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listAllLeagues {
            return leaguesViewModel?.result?.count ?? 0
        } else {
            return favoritesViewModel.result?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath) as! LeaguesTableViewCell
        
        (cell.viewWithTag(1) as! UIImageView).layer.cornerRadius = 30
        (cell.viewWithTag(1) as! UIImageView).backgroundColor = .white
        cell.layer.cornerRadius = 20
        
        
        if listAllLeagues {
            if let league = leaguesViewModel?.result?[indexPath.row] {
                (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: league.league_logo ?? dummyLeagueLogo))
                (cell.viewWithTag(2) as! UILabel).text = league.league_name
            }
        } else {
            let favLeague = favoritesViewModel.result?[indexPath.row]
            (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: favLeague?.league_logo ?? dummyLeagueLogo ))
            (cell.viewWithTag(2) as! UILabel).text = favLeague?.league_name
        }
        
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 50)
        
        UIView.animate(withDuration: 0.7, delay: 0.001 * Double(indexPath.row), options: .curveEaseInOut, animations: {
            cell.alpha = 1
            cell.transform = .identity
        }, completion: nil)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let leagueDetails = self.storyboard?.instantiateViewController(withIdentifier: "leagueDetails") as! LeagueDetailsViewController
            
            
            if listAllLeagues {
                
                leagueDetails.detailsVM = LeagueDetailsViewModel(sport: leaguesViewModel?.sport, leagueKey: leaguesViewModel?.result?[indexPath.row].league_key, league: leaguesViewModel?.result?[indexPath.row])
                leagueDetails.screenTitle = leaguesViewModel?.result?[indexPath.row].league_name
                
            } else {
                let favLeague = favoritesViewModel.result?[indexPath.row]
                leagueDetails.detailsVM = LeagueDetailsViewModel(sport: favoritesViewModel.sport, leagueKey: favLeague?.league_key, league: favLeague)
                leagueDetails.screenTitle = favLeague?.league_name
            }
            present(leagueDetails, animated: true)
            
            
        } else {
            let alert = UIAlertController(title: "No Internet Connection!", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if !listAllLeagues {
            if editingStyle == .delete {
                let alert = UIAlertController(title: "Are you sure?", message: "Do you really want to un-favourite this league?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Yes", style: .destructive) { UIAlertAction in
                    self.favoritesViewModel.removeFavourite(leagueKey: self.favoritesViewModel.result?[indexPath.row].league_key ?? 0)
                    self.favoritesViewModel.result?.remove(at: indexPath.row)
                    self.viewWillAppear(true)
                }
                let no = UIAlertAction(title: "No", style: .cancel)
                
                alert.addAction(yes)
                alert.addAction(no)
                present(alert, animated: true)
            }
        }
    }
    
    @IBAction func youtubeButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Alert!", message: "No Video Available", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}
