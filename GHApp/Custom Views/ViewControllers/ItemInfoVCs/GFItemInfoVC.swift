//
//  GFItemInfoVC.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/2/10.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

protocol ItemInfoVCDelegate: class {
    func didTapGitHubProfile(for user: User) /// 'for user:' - to give an excess to 'User'' Model
    func didTapGetFollowers(for user: User) /// 'for user:' -  to give an excess to 'User'' Model
}

class GFItemInfoVC: UIViewController {
    
    let stackView               = UIStackView()
    let littleItemInfoViewOne   = GFLittleItemInfoView()
    let littleItemInfoViewTwo   = GFLittleItemInfoView()
    let actionButton            = GFButton()
    
    var user:User!

    
    init(user: User){
        super.init(nibName: nil, bundle: nil) /// returns newly created ViewController , it is a default ViewController.
        self.user = user
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        configureStackView()
        layoutUI()
        configureActionButton()
    }


    func configureBackgroundView() {
        view.layer.cornerRadius     = 18
        view.backgroundColor        = .secondarySystemBackground
    }
    
    
    private func configureStackView() {
        stackView.axis          = .horizontal
        stackView.distribution  = .equalSpacing
        
        stackView.addArrangedSubview(littleItemInfoViewOne)
        stackView.addArrangedSubview(littleItemInfoViewTwo)
    }
    
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func actionButtonTapped() {}
    
    
    private func layoutUI() {
        view.addSubview(stackView)
        view.addSubview(actionButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding:CGFloat = 20
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
