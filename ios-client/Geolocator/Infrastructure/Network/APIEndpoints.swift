//
//  APIEndpoints.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 04.08.2026.
//

import Foundation

struct APIEndpoints {
    
    // MARK: - Auth
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
    
    static func getUserById(userId: Int) -> Endpoint {
        return Endpoint(
            path: "/auth/getUser/byId/\(userId)",
            method: .get,
            headers: nil,
            body: nil,
            queryItems: nil
        )
    }
    
    // MARK: - Location
    static func updateLocation(location: Location) -> Endpoint {
        let request = LocationRequestDTO(
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        return Endpoint(
            path: "/api/locations/update",
            method: .post,
            headers: nil,
            body: request,
            queryItems: nil
        )
    }
    
    // MARK: - Friends
    static func sendFriendRequest(user_id: Int) -> Endpoint {
        let request = SendFriendRequestRequestDTO(user_id: user_id)
        
        return Endpoint(
            path: "/api/friends/request/\(user_id)",
            method: .post,
            headers: nil,
            body: request,
            queryItems: nil
        )
    }
    
    static func getPengingRequests() -> Endpoint {
        return Endpoint(
            path: "/api/friends/requests",
            method: .get,
            headers: nil,
            body: nil,
            queryItems: nil
        )
    }
}
