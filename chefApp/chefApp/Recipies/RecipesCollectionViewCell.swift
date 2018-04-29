//
//  RecipesCollectionViewCell.swift
//  cs329
//
//  Created by Sai Kasam on 4/3/18.
//  Copyright © 2018 Sai Kasam. All rights reserved.
//

import UIKit

class RecipesCollectionViewCell: UICollectionViewCell {
    
    
    override func didMoveToWindow() {
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.cornerRadius = 8.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    

    
    
}
