//
//  GFItemInfoView.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/2/9.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class GFLittleItemInfoView: UIView {
    
    enum ItemInfoType { case repos, gists, followers, following }
    
    let symbolImageView = UIImageView()
    let titleLabel      = GFTittleLabel(textAlignment: .left, fontSize: 14)
    let countLabel      = GFTittleLabel(textAlignment: .center, fontSize: 14)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCombinedItemInfoVC()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureCombinedItemInfoVC () {
        addSubview(symbolImageView)
        addSubview(titleLabel)
        addSubview(countLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor   = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18), /// 18 is a bit bigger to settle 14..
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    
    func setInfo(infoItemType: ItemInfoType, withCount count: Int) {
        switch infoItemType {
        case .repos:
            symbolImageView.image       = SFSymbols.repos
            titleLabel.text             = "Public Repos"
        case .gists:
            symbolImageView.image       = SFSymbols.gists
            titleLabel.text             = "Public Gists"
        case .following:
            symbolImageView.image       = SFSymbols.following
            titleLabel.text             = "Following"
        case .followers:
            symbolImageView.image       = SFSymbols.followers
            titleLabel.text             = "Followers"
        }
        
        countLabel.text             = String(count)
    }
}
