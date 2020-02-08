//
//  GFBodyLabel.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/7.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class GFBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    
    private func configure () {
        textColor                       = .secondaryLabel //litegrey
        font                            = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth       = true
        minimumScaleFactor              = 0.75 // don't shrink font more that 75%
        lineBreakMode                   = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
    

}
