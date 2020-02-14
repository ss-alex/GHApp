//
//  GFFollowerItemVC.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/2/10.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import Foundation

class GFFollowerItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    private func configureItems() {
        littleItemInfoViewOne.setInfo(infoItemType: .following, withCount: user.following)
        littleItemInfoViewTwo.setInfo(infoItemType: .followers, withCount: user.followers)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }

    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
