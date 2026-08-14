//
//  UserModel.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 08.07.2026.
//

import Foundation

struct User {
    let id: Int
    let username: String
    let fullname: String
    let email: String
}

struct UserSession {
    let user: User
    let token: String
    
    func isValid() -> Bool {
        return !token.isEmpty
    }
}
