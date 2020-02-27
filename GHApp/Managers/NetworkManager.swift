//
//  NetworkManager.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/9.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

class NetworkManager { //creating a singleton
    static let shared           = NetworkManager() //static = every NetworkManager will have 'shared'
    private let baseUrl         = "https://api.github.com"
    let cache                   = NSCache<NSString,UIImage>()
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void){ ///completed=completionHandler
        let endpoint = baseUrl + "/users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error { //don't pass the new name because we just want to check if there is an error
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { /// if the response not nil and status 200
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder                 = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase ///  we changed before the keys in modal files 'Follower' & 'User'
                let followers               = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    func getUserInfo  (for username: String, completed: @escaping (Result<User, GFError>) -> Void){ ///completed=completionHandler
        let endpoint = baseUrl + "/users/\(username)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error { //don't pass the new name because we just want to check if there is an error
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { /// if the response not nil and status 200
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder                   = JSONDecoder()
                decoder.keyDecodingStrategy   = .convertFromSnakeCase ///  we changed before the keys in modal files 'Follower' & 'User'
                //decoder.dateDecodingStrategy  = .iso8601
                let user                      = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) { /// not a result type, because if the fetching is false, we gonna present a 'placeholder' icon
        let cacheKey = NSString(string: urlString) /// convertion from NSString to just a String
        
        if let image = cache.object(forKey: cacheKey) { ///checking if we have an image in the cache already
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed (nil)
                return
            }
            
            
            self.cache.setObject(image, forKey: cacheKey) /// to put an uploading image to cache not to download it again through the scrolling
            completed(image)
        }
        
        task.resume()
    }
}
    
    

