//
//  UserInfoVC.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/29.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

protocol UserInfoVCDelegate: class {
    func didTapGitHubProfile(for user: User) /// 'for user:' - to give an excess to 'User'' Model
    func didTapGetFollowers(for user: User) /// 'for user:' -  to give an excess to 'User'' Model
}

class UserInfoVC: GFDataLoadingVC {
    
    let headerView             = UIView()
    let itemViewOne            = UIView()
    let itemViewTwo            = UIView()
    let dateLabel              = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView]    = []
    
    var userName: String!
    weak var delegate: FollowerListVCDelegate!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    
    func configureViewController () {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissUserInfoVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    func getUserInfo () {
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
                
            case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func configureUIElements (with user: User) {
        
        let repoItemVC              = GFRepoItemVC(user: user)
        repoItemVC.delegate         = self
            
        let followerItemVC          = GFFollowerItemVC(user: user)
        followerItemVC.delegate     = self
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
    }
    
    
    func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        let padding: CGFloat        = 20
        let itemHeight: CGFloat     = 140
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        childVC.didMove(toParent: self)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
    }
    
    
    @objc func dismissUserInfoVC () { dismiss(animated: true) }

}


extension UserInfoVC: UserInfoVCDelegate {
    
    func didTapGitHubProfile(for user: User) {
            guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "URL attached to that user is invalid", buttonTitle: "Ok")
            return
        }
        
        showSafariView(for: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No Followers", message: "This User has no followers.", buttonTitle: "So Sad")
            return
        }
        delegate.didRequestFollowers(for: user.login)
    }
}
