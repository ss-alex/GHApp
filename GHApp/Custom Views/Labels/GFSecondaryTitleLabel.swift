//
//  GFSecondaryTitleLabel.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/2/7.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class GFSecondaryTitleLabel: UILabel {

    override init(frame: CGRect) {
           super.init(frame: frame)
           configure()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       
       init(fontSize: CGFloat) {
           super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
           configure()
       }
       
       
       private func configure () {
           textColor                       = .secondaryLabel //litegrey
           adjustsFontSizeToFitWidth       = true
           minimumScaleFactor              = 0.90 // don't shrink font more that 90%
           lineBreakMode                   = .byTruncatingTail // if text is long, it will be with 3 dots "..."
           translatesAutoresizingMaskIntoConstraints = false
       }

}
