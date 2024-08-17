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
    var sport: String!
    var leaguesViewModel: LeaguesViewModel?
    var favoritesViewModel = FavouritesViewModel()
    var indicator: UIActivityIndicatorView?
    
    var dummyLeagueLogo = "https://static.vecteezy.com/system/resources/previews/029/885/532/non_2x/trophy-icon-illustration-champion-cup-logo-vector.jpg"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if listAllLeagues{
            leaguesViewModel = LeaguesViewModel(sport: sport)
            favtitle.isHidden = true
            
            
            leaguesViewModel?.bindResultToViewController = {[weak self] in
                
                self?.tableView.reloadData()
                
            }
            
            leaguesViewModel?.loadDataFromApi()
            
        }else{
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
            if leaguesViewModel?.result?.count == 0 {
                let alert : UIAlertController = UIAlertController(title: "No Internet Connection.", message: "Please connect to a network to view the leagues.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                tableView.backgroundView = nil
            }
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
        cell.layer.cornerRadius = 20
        
        
        if listAllLeagues {
            if let league = leaguesViewModel?.result?[indexPath.row] {
                //    cell.setCell(league: league)
                (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: league.league_logo ?? dummyLeagueLogo))
                (cell.viewWithTag(2) as! UILabel).text = league.league_name
            }
        } else {
            let favLeague = favoritesViewModel.result?[indexPath.row]
            //   cell.setCell(league: favLeague)
            (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: favLeague?.league_logo ?? dummyLeagueLogo ))
            (cell.viewWithTag(2) as! UILabel).text = favLeague?.league_name
        }
        
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
                    leagueDetails.detailsVM = LeagueDetailsViewModel(leagueKey: favLeague?.league_key, league: favLeague)
                    leagueDetails.screenTitle = favLeague?.league_name
                }
                present(leagueDetails, animated: true)
                
            } else {
                let alert = UIAlertController(title: "Network Error", message: "No network connection found, cannot load data!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(ok)
                present(alert, animated: true)
            }
        }
        
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if !listAllLeagues {
                if editingStyle == .delete {
                    let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to un-favourite this league?", preferredStyle: .alert)
                    let yes = UIAlertAction(title: "Yes", style: .destructive) { UIAlertAction in
                        self.favoritesViewModel.removeFavourite(leagueKey: self.leaguesViewModel?.result?[indexPath.row].league_key ?? 0)
                        self.favoritesViewModel.result?.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.viewWillAppear(true)
                    }
                    let no = UIAlertAction(title: "No", style: .cancel)
                    
                    alert.addAction(yes)
                    alert.addAction(no)
                    present(alert, animated: true)
                }
            }
        }
        
        
    }

