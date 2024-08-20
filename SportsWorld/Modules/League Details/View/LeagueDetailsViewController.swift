//
//  LeagueDetailsViewController.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 13/08/2024.
//

import UIKit
import Kingfisher
import Alamofire

class LeagueDetailsViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
   
    
    @IBOutlet weak var leagueTitle: UILabel!
    
    @IBOutlet weak var favItem: UIButton!
    
    @IBOutlet weak var collection: UICollectionView!
    
    var detailsVM : LeagueDetailsViewModel?

    var isFavourited = false
    var screenTitle: String?
    var sport : String?
    var dummyTeamLogo = "https://cdn-icons-png.freepik.com/512/9192/9192876.png"
    
    var indicator: UIActivityIndicatorView?
    
    var currentIndexPath: IndexPath?
    let pressedDownTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        collection.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")

        
        leagueTitle.text = screenTitle

        
        collection.dataSource = self
        collection.delegate = self
        
        indicator = UIActivityIndicatorView.init(style: .large)
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didTapLongPress))
        longPressRecognizer.minimumPressDuration = 0.0000001
        longPressRecognizer.cancelsTouchesInView = false
        longPressRecognizer.delegate = self
        collection.addGestureRecognizer(longPressRecognizer)
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
       isFavourite()
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
            
            latestCell.layer.cornerRadius = 30
            
            // Initial state before animation
            latestCell.alpha = 0
            latestCell.transform = CGAffineTransform(translationX: 0, y: 50)
            
            // Animation block
            UIView.animate(withDuration: 0.7, delay: 0.001 * Double(indexPath.row), options: .curveEaseInOut, animations: {
                latestCell.alpha = 1
                latestCell.transform = .identity
            }, completion: nil)
           
            return latestCell
        case 2 :
            
            teamCell.teamlogo.kf.setImage(with: URL(string: detailsVM?.leagueTeams[indexPath.row].home_team_logo ?? dummyTeamLogo))
            (teamCell.viewWithTag(1) as! UIImageView).layer.cornerRadius = 45
            (teamCell.viewWithTag(1) as! UIImageView).backgroundColor = .white
            (teamCell.viewWithTag(1) as! UIImageView).layer.zPosition = 1

            teamCell.teamnamelabel.text = detailsVM?.leagueTeams[indexPath.row].event_home_team ?? "Team Name"
            teamCell.layer.cornerRadius = 40

            // Initial state before animation
            teamCell.alpha = 0
            teamCell.transform = CGAffineTransform(translationX: 50, y: 0)
            
            // Animation block
            UIView.animate(withDuration: 0.7, delay: 0.001 * Double(indexPath.row), options: .curveEaseInOut, animations: {
                teamCell.alpha = 1
                teamCell.transform = .identity
            }, completion: nil)

            return teamCell
            
        default:
            return latestCell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
        
        switch indexPath.section {
        case 0:
            header.setText("Up Coming")
            
        case 1:
            header.setText("Latest")
           
        case 2:
            header.setText("Teams")
        default:
            header.setText("Default Header")
            header.backgroundColor = .gray
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if NetworkReachabilityManager()?.isReachable ?? false {
                let teamScreen = self.storyboard?.instantiateViewController(withIdentifier: "teamDetails") as! TeamsViewController
                teamScreen.sport = detailsVM?.sport
                teamScreen.teamKey = detailsVM?.leagueTeams[indexPath.row].home_team_key
                //teamScreen.pageTitle = teams?[indexPath.row].team_title
                present(teamScreen, animated: true)
            } else {
                let alert = UIAlertController(title: "No Internet Connection!", message: "Please check your internet connection and try again.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(ok)
                present(alert, animated: true)
            }
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
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]

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
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]

        return section
    }
    
    func drawTheBottomSection()-> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 8, bottom: 16, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }

    func isFavourite() {
        let isFavourited = CoreDataManager.shared.isFavourited(leagueKey: detailsVM?.leagueKey ?? 0)
        
        if isFavourited {
            favItem.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else{
            favItem.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @IBAction func favBtn(_ sender: Any) {
        
        let isFavourited = CoreDataManager.shared.isFavourited(leagueKey: detailsVM?.leagueKey ?? 0)
        
        if isFavourited {
            favItem.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        else{
            favItem.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        detailsVM?.editInCoreData(league: (detailsVM?.league)!, leagueKey: detailsVM?.leagueKey ?? 0, isFavourite: isFavourited, sport: (detailsVM?.sport) ?? "")
        
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    // Animation
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func didTapLongPress(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: collection)
        let indexPath = collection.indexPathForItem(at: point)

        let isLastSection = indexPath?.section == 2
        
        guard isLastSection, let indexPath = indexPath, let cell = collection.cellForItem(at: indexPath) else {
            if let currentIndexPath = currentIndexPath, let currentCell = collection.cellForItem(at: currentIndexPath) {
                animate(currentCell, to: .identity)
            }
            currentIndexPath = nil
            return
        }

        if sender.state == .began {
            animate(cell, to: pressedDownTransform)
            currentIndexPath = indexPath
        } else if sender.state == .changed {

            if indexPath != currentIndexPath, let currentIndexPath = currentIndexPath, let cell = collection.cellForItem(at: currentIndexPath) {
                if cell.transform != .identity {
                    animate(cell, to: .identity)
                }
            } else if indexPath == currentIndexPath, let cell = collection.cellForItem(at: indexPath) {
                if cell.transform != pressedDownTransform {
                    animate(cell, to: pressedDownTransform)
                }
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            if let currentIndexPath = currentIndexPath, let cell = collection.cellForItem(at: currentIndexPath) {
                animate(cell, to: .identity)
                self.currentIndexPath = nil
            }
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
