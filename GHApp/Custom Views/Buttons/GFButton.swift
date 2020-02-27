//
//  GFButton.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/4.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(backgroundColor: UIColor, tittle: String) {
        self.init(frame: .zero) // set the frame to .zero since constraints will be added later
        self.backgroundColor = backgroundColor
        self.setTitle(tittle, for: .normal)
    }
    
    
    private func configure() {
        layer.cornerRadius                          = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font                            = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints   = false
    }
    
    
    func set(backgroundColor:UIColor, title: String) { /// despite here is the init method that is appropriate for that task, sometimes it is needed to change 'backgroundColor' and 'title' in the  specific way
        self.backgroundColor    = backgroundColor
        setTitle(title, for: .normal)
    }
    
}
