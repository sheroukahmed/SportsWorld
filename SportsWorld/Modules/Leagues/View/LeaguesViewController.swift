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
    
    var listAllLeagues: Bool!
    var sport: String!
    var leaguesViewModel: LeaguesViewModel?
    var result: [League]?
    var favouriteLeagues: [NSManagedObject]?
    var indicator: UIActivityIndicatorView?
    
    var dummyLeagueLogo = "https://static.vecteezy.com/system/resources/previews/029/885/532/non_2x/trophy-icon-illustration-champion-cup-logo-vector.jpg"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        

        indicator = UIActivityIndicatorView.init(style: .large)
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
        leaguesViewModel = LeaguesViewModel()
        leaguesViewModel?.sport = sport
        
        listAllLeagues ? leaguesViewModel?.loadDataFromApi() : leaguesViewModel?.loadDatafromCoreData()
        
        leaguesViewModel?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                print("Leagues fetched: \(self?.result?.count ?? 0)")
                self?.indicator?.stopAnimating()
                self?.result = self?.leaguesViewModel?.getLeagues()
                self?.tableView.reloadData()
            }
        }
        
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
            if favouriteLeagues?.count == 0 {
                noFavouriteImage.isHidden = false
            }
            return favouriteLeagues?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath)
        (cell.viewWithTag(1) as! UIImageView).layer.cornerRadius = 30
        cell.layer.cornerRadius = 20
        
        
        if listAllLeagues {
            if let league = result?[indexPath.row] {
                (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: league.league_logo ?? dummyLeagueLogo))
                (cell.viewWithTag(2) as! UILabel).text = league.league_name
            }
        } else {
            if let favLeague = favouriteLeagues?[indexPath.row] {
                (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: favLeague.value(forKey: "league_logo") as? String ?? dummyLeagueLogo ))
                (cell.viewWithTag(2) as! UILabel).text = favLeague.value(forKey: "league_name") as? String
            }
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if NetworkReachabilityManager()?.isReachable ?? false {
            let leagueDetails = self.storyboard?.instantiateViewController(withIdentifier: "leagueDetails") as! LeagueDetailsViewController
            
            leagueDetails.sport = self.sport
            leagueDetails.leagueKey = result?[indexPath.row].league_key
            leagueDetails.screenTitle = result?[indexPath.row].league_name
            
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
                    self.leaguesViewModel?.removeFavourite(leagueKey: self.favouriteLeagues?[indexPath.row].value(forKey: "league_key") as! Int, sport: self.favouriteLeagues?[indexPath.row].value(forKey: "sport") as! String)
                    self.viewDidAppear(true)
                }
                let no = UIAlertAction(title: "No", style: .cancel)
                
                alert.addAction(yes)
                alert.addAction(no)
                present(alert, animated: true)
            }
        }
    }
    
   
    
}
