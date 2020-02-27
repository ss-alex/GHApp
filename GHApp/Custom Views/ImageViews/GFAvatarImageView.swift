//
//  GFAvatarImageView.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/13.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache               = NetworkManager.shared.cache
    let placeholderImage    = Images.placeholderImage
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius  = 10
        clipsToBounds       = true /// make image be within the layer + cornered edges
        image               = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}
