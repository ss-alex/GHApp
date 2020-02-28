//
//  PersistenceManager.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/2/19.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import Foundation


enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys { static let favouritesKey = "favorites" }
    
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites{ result in
            switch result {
            case .success(var favorites):
                
                switch actionType{
                case .add:
                    guard !favorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll {$0.login == favorite.login} /// $0 = each item
                }
                
                completed(save(favorites: favorites))
                
                
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        /// as far as we save a complex array to the defaults, we will have to decode it to Data first, and when we use it - we decode it, at second /// [Follower] - [Favourites], a type of 'Follower''
        
        guard let favoritesData = defaults.object(forKey: Keys.favouritesKey) as? Data else {
            completed(.success([])) /// it returns an empty array if the 'favoritesData' equals to 'nil'
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    
    static func save(favorites: [Follower]) -> GFError? { /// if saving is successful, we gonna return 'nil'
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favouritesKey)
            return nil /// we are returning 'nil' because no error happens
        } catch {
            return .unableToFavorite /// if this encode fails, we can return '.unableToFavorite' type of error
        }
    }
}
