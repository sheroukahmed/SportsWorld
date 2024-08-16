//
//  LeagueDetailsViewController.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 13/08/2024.
//

import UIKit
import Kingfisher

class LeagueDetailsViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var leagueTitle: UILabel!
    
    @IBOutlet weak var favItem: UIButton!
    let heart = UIImage(systemName: "heart") as UIImage?
    let filledHeart = UIImage(systemName: "heart.fill") as UIImage?
    
    @IBOutlet weak var collection: UICollectionView!
    
    var detailsVM : LeagueDetailsViewModel?

    var isFavourite = false
    var sport: String?
    var league: League?
    var leagueKey: Int?
    var screenTitle: String?
    
    var dummyTeamLogo = "https://cdn-icons-png.freepik.com/512/9192/9192876.png"
    
    var indicator: UIActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        leagueTitle.text = screenTitle

        
        collection.dataSource = self
        collection.delegate = self
        
        indicator = UIActivityIndicatorView.init(style: .large)
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
        
        let layout = UICollectionViewCompositionalLayout {sectionIndex,enviroment in
                    switch sectionIndex {
                    case 0 :
                        return self.drawTheTopSection()
                    case 1 :
                        return self.drawTheMiddleSection()
                    default:
                        return self.drawTheBottomSection()
                    }
                }
        collection.setCollectionViewLayout(layout, animated: true)
        
       // collection.reloadData()
        
        detailsVM = LeagueDetailsViewModel()
        detailsVM?.sport = sport
        detailsVM?.leagueKey = leagueKey

        
        detailsVM?.loadData()
        
        detailsVM?.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.indicator?.stopAnimating()
                
                guard let self = self else { return }
                
                self.collection.reloadData()
            }
            
        }
        detailsVM?.loadData()
        
    }
   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch(section){
        case 0 :
            return detailsVM?.upEvents?.count ?? 1
        case 1 :
            return detailsVM?.lateEvents?.count ?? 1
        case 2 :
            return detailsVM?.leagueTeams.count ?? 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let upcomingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath) as! UpcomingCollectionViewCell
        let latestCell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestCell", for: indexPath) as! LatestCollectionViewCell
        let teamCell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as! TeamsCollectionViewCell
        
        switch(indexPath.section){
        case 0 :
            
            upcomingCell.hometeamlogo.kf.setImage(with: URL(string: detailsVM?.upEvents?[indexPath.row].home_team_logo ?? dummyTeamLogo))
            
            upcomingCell.awayteamlogo.kf.setImage(with: URL(string: detailsVM?.upEvents?[indexPath.row].away_team_logo ??  dummyTeamLogo))
            
            upcomingCell.datelabel.text = "\(detailsVM?.upEvents?[indexPath.row].event_date ?? "eventDate")"
            upcomingCell.timelabel.text = "\(detailsVM?.upEvents?[indexPath.row].event_time ?? "eventTime")"
            
            upcomingCell.hometeamlabel.text = detailsVM?.upEvents?[indexPath.row].event_home_team
            
            upcomingCell.awayteamlabel.text = detailsVM?.upEvents?[indexPath.row].event_away_team
            
            return upcomingCell
            
        case 1 :
            
            latestCell.hometeamlogo.kf.setImage(with: URL(string: detailsVM?.lateEvents?[indexPath.row].home_team_logo ??  dummyTeamLogo))
            latestCell.awayteamlogo.kf.setImage(with: URL(string: detailsVM?.lateEvents?[indexPath.row].away_team_logo ?? dummyTeamLogo))
            latestCell.datelabel.text = "\(detailsVM?.lateEvents?[indexPath.row].event_date ?? "eventDate")"
            latestCell.timelabel.text = "\(detailsVM?.lateEvents?[indexPath.row].event_time ?? "eventTime")"
            
            latestCell.scorelabel.text = detailsVM?.lateEvents?[indexPath.row].event_final_result
            latestCell.hometeamlabel.text = detailsVM?.lateEvents?[indexPath.row].event_home_team
            latestCell.awayteamlabel.text = detailsVM?.lateEvents?[indexPath.row].event_away_team
           
            return latestCell
        case 2 :
            
            teamCell.teamlogo.kf.setImage(with: URL(string: detailsVM?.leagueTeams[indexPath.row].home_team_logo ?? dummyTeamLogo))
            teamCell.teamnamelabel.text = detailsVM?.leagueTeams[indexPath.row].event_home_team ?? "Team Name"
            
            return teamCell
            
        default:
            return latestCell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2{
            let teamScreen = self.storyboard?.instantiateViewController(withIdentifier: "teamDetails") as! TeamsViewController
            teamScreen.sport = sport
            teamScreen.teamKey = detailsVM?.leagueTeams[indexPath.row].home_team_key
            //teamScreen.pageTitle = teams?[indexPath.row].team_title
            present(teamScreen, animated: true)
        }
    }
    

    
    func drawTheTopSection()-> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 0)
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        
        return section
    }
    
    func drawTheMiddleSection() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.95))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        return section
    }
    
    func drawTheBottomSection()-> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 8, bottom: 16, trailing: 0)
        
        return section
    }

    
    @IBAction func favBtn(_ sender: Any) {
        
        isFavourite = !isFavourite
        favItem.setImage(UIImage(systemName: isFavourite ? "heart.fill" : "heart"), for: .normal)
        
        detailsVM?.editInCoreData(league: league!, sport: sport!, favourite: isFavourite)
    }
    
}
