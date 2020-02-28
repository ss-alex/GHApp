//
//  FavoriteCell.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/2/22.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    static let reuseID = "FavoriteCell"
    
    let avatarImageView = GFAvatarImageView(frame: .zero) /// .zero because the constraints will be defined later
    let userNameLabel = GFTittleLabel(textAlignment: .left, fontSize: 26)

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTextAndImageFor(favorite: Follower) {
        userNameLabel.text = favorite.login
        avatarImageView.downloadAvatarImage(fromURL: favorite.avatarUrl)
    }
    
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(userNameLabel)
        accessoryType               = .disclosureIndicator /// small arrow on the right of the customed table view cell
        let padding:CGFloat         = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

