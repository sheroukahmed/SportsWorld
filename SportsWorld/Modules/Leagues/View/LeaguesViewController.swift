//
//  LeaguesViewController.swift
//  SportsWorld
//
//  Created by Sarah on 15/08/2024.
//

import UIKit
import Kingfisher


class LeaguesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var sport: String!
    var leaguesViewModel: LeaguesViewModel?
    var result: [League]?
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
        
        leaguesViewModel?.loadDataFromApi()
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
        if result?.count == 0 {
            let alert : UIAlertController = UIAlertController(title: "No Internet Connection.", message: "Please connect to a network to view the leagues.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            tableView.backgroundView = nil
        }
        return result?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath)
        
        if let league = result?[indexPath.row] {
            (cell.viewWithTag(1) as! UIImageView).layer.cornerRadius = 30
            (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: league.league_logo ?? dummyLeagueLogo))
            (cell.viewWithTag(2) as! UILabel).text = league.league_name
            
            cell.layer.cornerRadius = 20
        }
        

        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leagueDetails = self.storyboard?.instantiateViewController(withIdentifier: "leagueDetails") as! LeagueDetailsViewController
        
        leagueDetails.sport = self.sport
        leagueDetails.leagueKey = result?[indexPath.row].league_key
        leagueDetails.screenTitle = result?[indexPath.row].league_name

        present(leagueDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func reloadArray() {
        leaguesViewModel?.loadDatafromCoreData()
    }
    
}
