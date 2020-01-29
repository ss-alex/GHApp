//
//  FollowerListVC.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/6.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class FollowerListVC: UIViewController {
    
    enum Section { case main }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        getFollowers(username: username, page: page)
        configureCollectionView()
        configureDataSource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func getFollowers(username: String, page: Int){
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in /// making self weak to deal with memory leaks
            guard let self = self else {return} ///unwraping optional self(s) below..
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false } /// if it's less then 100 followers, we need to stop network calling
                self.followers.append(contentsOf: followers) /// to add the followers from other pages to the main array of followers
                
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 👻."
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                
                self.updateData(on: self.followers) /// launch collection view creation /// it's here because we will need to update snapshots a lot when scroll down /// self - because we need to the super view var 'followers', not local var.
                
            case .failure(let error): /// Just naming the parameter to refer to it.
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    
    func configureViewController() { /// color of the VC and NavBar size
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true ///navigationBarTitle is big, left edge
    }
    
    
    func configureCollectionView() {  /// configure structure & layout of the collectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self /// delegate listens to 'FollowerListVC: UICollectionViewDelegate'
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID) /// registering the cell for the DataSource
    }
    
    
    func configureSearchController() {
        let searchController                                    = UISearchController()
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.delegate                     = self
        searchController.searchBar.placeholder                  = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation   = false /// not to make a darkening of the view
        navigationItem.searchController                         = searchController
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in /// the cell with populated textLabels is returned
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            
            cell.set(follower: follower) /// make changes on the created cell (add text to the userNameLabel)
            return cell
        })
    }
    
    
    func updateData(on follower: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }

}

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY             = scrollView.contentOffset.y
        let contentHeight       = scrollView.contentSize.height
        let height              = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return } /// as far as it is variable, if there are less then 100 followers the var will turn into the 'false'
            page += 1
            getFollowers(username: username, page: page)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray         = isSearching ? filteredFollowers : followers
        let follower            = activeArray[indexPath.item] /// it is connected to the item that is tapped
        
        let userInfoVC          = UserInfoVC()
        userInfoVC.userName     = follower.login
        let navController       = UINavigationController(rootViewController: userInfoVC)
        
        present(navController, animated: true)
    }
    
}


extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
    
    
}
 
