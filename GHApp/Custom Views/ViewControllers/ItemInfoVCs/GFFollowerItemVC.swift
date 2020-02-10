//
//  GFFollowerItemVC.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/2/10.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import Foundation

class GFFollowerItemVC: GFCombinedItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    private func configureItems() {
        littleItemInfoViewOne.set(infoItemType: .following, withCount: user.following)
        littleItemInfoViewTwo.set(infoItemType: .followers, withCount: user.followers)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }

}
