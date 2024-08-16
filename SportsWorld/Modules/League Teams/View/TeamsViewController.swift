//
//  TeamsViewController.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 14/08/2024.
//

import UIKit

class TeamsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var teamname: UILabel!
    @IBOutlet weak var teamlogo: UIImageView!
    
    @IBOutlet weak var playerstable: UITableView!
    
    var teamKey: Int!
    var sport: String!
    var TeamsVM : TeamsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerstable.delegate = self
        playerstable.dataSource = self
        
        let nib = UINib(nibName: "PlayersTableViewCell", bundle: nil)
        playerstable.register(nib, forCellReuseIdentifier: "playercell")
        
        TeamsVM = TeamsViewModel()
        TeamsVM?.sport = sport
        TeamsVM?.teamKey = teamKey
        TeamsVM?.loadData()
        TeamsVM?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                //self?.indicator?.stopAnimating()
                
                self?.teamlogo.kf.setImage(with: URL(string: self?.TeamsVM?.result?.team_logo ?? "https://media.istockphoto.com/id/464558990/photo/stadium-night-in-a-soccer-stadium.jpg?s=612x612&w=0&k=20&c=S7lz2Qn-4eFrSrB5x2txzksOshDwNB3HKIKn14FaTrc="))
                self?.teamname.text = self?.TeamsVM?.result?.team_name

                self?.playerstable.reloadData()
            }
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TeamsVM?.result?.players.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = playerstable.dequeueReusableCell(withIdentifier: "playercell", for: indexPath) as? PlayersTableViewCell else {
                    return UITableViewCell()
                }
        
//        cell.playerimage.kf.setImage(with: URL(string: TeamsVM?.result?.players[indexPath.row].player_image ?? "https://b.fssta.com/uploads/application/soccer/headshots/40670.vresize.350.350.medium.91.png"))
        
        cell.playernolabel.text = TeamsVM?.result?.players[indexPath.row].player_number ?? "00" + ". "
        cell.playernamelabel.text = TeamsVM?.result?.players[indexPath.row].player_name ?? "Mbappe"
        cell.playerpositionlabel.text = TeamsVM?.result?.players[indexPath.row].player_type ?? "Mbappe"
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }


}
