//
//  APIEndpoints.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 04.08.2026.
//

import Foundation

struct APIEndpoints {
    static func register(username: String, fullname: String, email: String, password: String) -> Endpoint {
        let request = RegisterRequestDTO(
            username: username,
            fullname: fullname,
            email: email,
            password: password
        )
        
        return Endpoint(
            path: "/auth/register",
            method: .post,
            headers: nil,
            body: request,
            queryItems: nil
        )
    }
    
    static func login(email: String, password: String) -> Endpoint {
        let request = LoginRequestDTO(
            email: email,
            password: password
        )
        
        return Endpoint(
            path: "/auth/login",
            method: .post,
            headers: nil,
            body: request,
            queryItems: nil
        )
    }
}
