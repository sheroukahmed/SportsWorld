//
//  SectionHeader.swift
//  SportsWorld
//
//  Created by  sherouk ahmed  on 19/08/2024.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    let titleLabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            configure()
        }
        
        private func configure() {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        func setText(_ text: String) {
            titleLabel.text = text
        }
    
}
