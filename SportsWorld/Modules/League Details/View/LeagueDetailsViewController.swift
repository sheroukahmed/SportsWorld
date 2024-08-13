//
//  LeagueDetailsViewController.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 13/08/2024.
//

import UIKit

class LeagueDetailsViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var FavItem: UIButton!
    
    @IBOutlet weak var collection: UICollectionView!
    
    var sport: String!
    var leagueKey: Int?
    
    var indicator: UIActivityIndicatorView?
    
    var detailsVM : LeagueDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        indicator?.center = self.view.center
//        indicator?.startAnimating()
//        self.view.addSubview(indicator!)
        
        collection.dataSource = self
        collection.delegate = self
        
        
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
        
        collection.reloadData()



    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch(section){
        case 0 :
            return 4
        case 1 :
            return 5
        case 2 :
            return 10
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let upcomingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath)
        let latestCell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestCell", for: indexPath)
        let teamCell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath)
        
        switch(indexPath.section){
        case 0 :
            
            return upcomingCell
        case 1 :
            
            return latestCell
        case 2 :
            return teamCell
            
            
        default:
            return latestCell
            
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

    

}
