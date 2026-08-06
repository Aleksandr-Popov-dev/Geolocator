//
//  RegisterDTOs.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 05.08.2026.
//

import Foundation

struct RegisterRequestDTO: Encodable {
    let username: String
    let fullname: String
    let email: String
    let password: String
}

struct RegisterResponseDTO: Decodable {
    let id: Int
    let username: String
    let fullname: String
    let email: String
    
    //MARK: JWT token
    let access_token: String?
    let token_type: String?
    
    func toDomain() -> (user: User, token: String?) {
        let user = User(
            id: String(id),
            username: username,
            fullname: fullname,
            email: email
        )
        
        return (user, access_token)
    }
}
