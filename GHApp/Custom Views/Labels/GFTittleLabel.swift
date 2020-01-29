//
//  GFTittleLabel.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/7.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class GFTittleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }
    
    
    private func configure () {
        textColor                       = .label /// white in dark mode and black in white mode
        adjustsFontSizeToFitWidth       = true
        minimumScaleFactor              = 0.9 /// don't shrink font more that 90%
        lineBreakMode                   = .byTruncatingTail /// add 3 dots in the end if the label is long
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
