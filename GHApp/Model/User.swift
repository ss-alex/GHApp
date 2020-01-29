//
//  User.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/1/8.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    let name: String?
    let location: String?
    let bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: String
}
