//
//  FavoritesListVC.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/3.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {

    let tableView               = UITableView()
    var favorites: [Follower]   = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame             = view.bounds
        tableView.rowHeight         = 80
        tableView.removeExcessCells()
        tableView.delegate          = self
        tableView.dataSource        = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No Favorites?\nAdd one new follower screen.", in: self.view) /// \n is for hardcoding the sentence before \n on one line and the rest on another line
                } else {
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
                
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}


extension FavoritesListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /// configure each cell every time it appears on screen
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell /// we cast 'cel' as 'FavoriteCell' because we need to have a possibility to reach function 'setTextAndImageFor' inside the class 'FavoriteCell'
        let favorite = favorites[indexPath.row] /// 'indexPath.row''returns an int, and that's the index we are grabbing based on where it's at in the tableView row
        cell.setTextAndImageFor(favorite: favorite) /// every time we scroll down, cellForRowAt is called, and 'setTextAndImageFor' is called through 'FavoriteCell'
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite        = favorites[indexPath.row]
        let destVC          = FollowerListVC(username: favorite.login)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        /// delegation function for swipe gestures
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.favorites.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                return } /// return if we don't have an error
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")/// if we have an error
        }
    }
    
    

}
