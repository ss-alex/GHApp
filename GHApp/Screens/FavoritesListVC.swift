//
//  FavoritesListVC.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/3.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class FavoritesListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue
        
        PersistenceManager.retrieveFavorites{ result in
            switch result {
            case .success(let favorites):
                print(favorites)
            case .failure(let error):
                break
            }
        }
    }


}
