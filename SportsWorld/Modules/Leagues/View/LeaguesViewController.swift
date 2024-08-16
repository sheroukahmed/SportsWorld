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
    
    
    var listAllLeagues = false
    var sport: String!
    var leaguesViewModel: LeaguesViewModel?
    var result: [League]?
    var favouriteLeagues = [League]()
    var indicator: UIActivityIndicatorView?
    
    var dummyLeagueLogo = "https://static.vecteezy.com/system/resources/previews/029/885/532/non_2x/trophy-icon-illustration-champion-cup-logo-vector.jpg"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        leaguesViewModel = LeaguesViewModel()
        leaguesViewModel?.sport = sport
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
                
        if listAllLeagues {
            
            indicator = UIActivityIndicatorView.init(style: .large)
            indicator?.center = self.view.center
            indicator?.startAnimating()
            self.view.addSubview(indicator!)
           
            leaguesViewModel?.loadDataFromApi()
            
            leaguesViewModel?.bindResultToViewController = { [weak self] in
                DispatchQueue.main.async {
                    print("Leagues fetched: \(self?.result?.count ?? 0)")
                    self?.indicator?.stopAnimating()
                    self?.result = self?.leaguesViewModel?.getLeagues()
                    self?.tableView.reloadData()
                }
            }
        } else {
            favouriteLeagues = leaguesViewModel?.loadDatafromCoreData() ?? []
            self.indicator?.stopAnimating()

            if favouriteLeagues.count == 0 {
                noFavouriteImage.isHidden = false
                tableView.isHidden = true
            }
            tableView.reloadData()
        }
        
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listAllLeagues {
            if result?.count == 0 {
                let alert : UIAlertController = UIAlertController(title: "No Internet Connection.", message: "Please connect to a network to view the leagues.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                tableView.backgroundView = nil
            }
            return result?.count ?? 0
        } else {
            return favouriteLeagues.count 
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
            if let league = result?[indexPath.row] {
            //    cell.setCell(league: league)
                (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: league.league_logo ?? dummyLeagueLogo))
                (cell.viewWithTag(2) as! UILabel).text = league.league_name
            }
        } else {
            let favLeague = favouriteLeagues[indexPath.row]
            //   cell.setCell(league: favLeague)
            (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: favLeague.league_logo ?? dummyLeagueLogo ))
            (cell.viewWithTag(2) as! UILabel).text = favLeague.league_name
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let leagueDetails = self.storyboard?.instantiateViewController(withIdentifier: "leagueDetails") as! LeagueDetailsViewController
            
            if listAllLeagues {
                leagueDetails.sport = self.sport
                leagueDetails.league = result?[indexPath.row]
                leagueDetails.leagueKey = result?[indexPath.row].league_key
                leagueDetails.screenTitle = result?[indexPath.row].league_name
            } else {
                let favLeague = favouriteLeagues[indexPath.row]
                leagueDetails.sport = ""
                leagueDetails.league = favLeague
                leagueDetails.leagueKey = favLeague.league_key
                leagueDetails.screenTitle = favLeague.league_name
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
                    self.leaguesViewModel?.removeFavourite(leagueKey: self.favouriteLeagues[indexPath.row].league_key!)
                    self.favouriteLeagues.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                let no = UIAlertAction(title: "No", style: .cancel)
                
                alert.addAction(yes)
                alert.addAction(no)
                present(alert, animated: true)
            }
        }
    }
    
    
}
