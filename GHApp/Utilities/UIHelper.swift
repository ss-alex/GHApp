//
//  UIHelper.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/19.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

struct UIHelper {
    
    static func createThreeColumnLayout(in view: UIView) -> UICollectionViewFlowLayout { /// created to be inserted into the collectionViewLayout
        
        let width                           = view.bounds.width
        let padding: CGFloat                = 12
        let minumumItemsSpacing: CGFloat    = 10
        let availableWidth                  = width - (padding * 2) - (minumumItemsSpacing * 2)
        let itemWidth                       = availableWidth / 3
        
        let flowLayout                      = UICollectionViewFlowLayout()
        flowLayout.sectionInset             = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize                 = CGSize(width: itemWidth, height: (itemWidth + 40))
        
        return flowLayout
    }
    
}
