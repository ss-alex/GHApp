//
//  GFError.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/2/7.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername        = "This username created an invalid request. Please try again."
    case unableToComplete       = "Unable to complete your request. Please check your internet connection."
    case invalidResponse        = "Invalid response from the server. Please try again."
    case invalidData            = "The data received from the server was invalid. Please try again."
    case unableToFavorite       = "There was an error favoriting this user. Please try it again."
    case alreadyInFavorites    = "You've already favorited this user."
}

