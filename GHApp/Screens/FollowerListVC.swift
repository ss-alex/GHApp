//
//  FollowerListVC.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/6.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

protocol FollowerListVCDelegate: class {
    func didRequestFollowers(for username: String)
}

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
    
    
    func configureViewController() { /// color of the VC and NavBar.Tittle size
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true ///navigationBarTitle is big, left edge
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result{
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user", buttonTitle: "Hooray!") /// if error is nil, we call 'presentGFAlertOnMainThread'
                        return
                    }
                    self.presentGFAlertOnMainThread(title: "Something went wrong.", message: error.rawValue, buttonTitle: "Ok") /// if error is not 'nil'
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
            
        }
        
    }
    
    
    func configureSearchController() {
        let searchController                                    = UISearchController()
        searchController.searchResultsUpdater                   = self /// update search results when smth is inserted
        searchController.searchBar.delegate                     = self
        searchController.searchBar.placeholder                  = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation   = false /// not to make a darkening of the view
        navigationItem.searchController                         = searchController
    }
    
    
    func getFollowers(username: String, page: Int) {
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
                
                self.updateDataOnScreen(on: self.followers) /// launch collection view creation /// it's here because we will need to update snapshots a lot when scroll down /// self - because we need to the super view var 'followers', not local var.
                
            case .failure(let error): /// Just naming the parameter to refer to it.
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

        
    func configureCollectionView() {  /// configure structure & layout of the collectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self /// delegate listens to 'FollowerListVC: UICollectionViewDelegate'
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID) /// registering the cell for the DataSource
    }
    

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in /// the cell with populated textLabels is returned
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            
            cell.setTextAndImageFor(follower: follower) /// make changes on the created cell (add text to the userNameLabel)
            return cell
        })
    }
    
    
    func updateDataOnScreen(on follower: [Follower]) {
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
        let screenHeight        = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight {
            guard hasMoreFollowers else { return } /// as far as it is variable, if there are less then 100 followers the var will turn into the 'false'
            page += 1
            getFollowers(username: username, page: page)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let activeArray         = isSearching ? filteredFollowers : followers /// if (isSearching) = true, then (filteredFollowers), else (fo.rs)
        let follower            = activeArray[indexPath.item] /// it is connected to the item that is tapped
        let destinationVC       = UserInfoVC()
        destinationVC.userName  = follower.login
        destinationVC.delegate  = self /// 'FollowerListVC' is listening to the 'UserInfoVC''
        let navController       = UINavigationController(rootViewController: destinationVC)
        
        present(navController, animated: true)
    }
    
}


extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateDataOnScreen(on: filteredFollowers)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateDataOnScreen(on: followers)
    }
}


extension FollowerListVC: FollowerListVCDelegate { /// extension for interaction with UserInfoVC when the button is tapped
    
    func didRequestFollowers(for username: String) {
        self.username   = username
        title           = username
        page            = 1 /// reset page to 1 (it could be any number in the memory after we fetched the followers before)
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true) /// scroll up to the limit
        getFollowers(username: username, page: page)
    }
    
    
}
 
