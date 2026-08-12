//
//  AuthRepository.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 04.08.2026.
//

import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let tokenStorage: TokenStorageProtocol
    
    init(networkService: NetworkServiceProtocol, tokenStorage: TokenStorageProtocol) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    func login(email: String, password: String) async throws -> User {
        let endpoint = APIEndpoints.login(
            email: email,
            password: password
        )
        
        let response: LoginResponseDTO = try await networkService.request(endpoint)
        let (user, token) = response.toDomain()
        
        if let token = token {
            try tokenStorage.saveToken(token)
            print("JWT token is save: log")
        }
        
        return user        
    }
    
    func register(username: String, fullname: String, email: String, password: String) async throws -> User {
        let endpoint = APIEndpoints.register(
            username: username,
            fullname: fullname,
            email: email,
            password: password
        )
        
        let response: RegisterResponseDTO = try await networkService.request(endpoint)
        let (user, token) = response.toDomain()
        
        if let token = token {
            try tokenStorage.saveToken(token)
            print("JWT token is save: reg")
        }
        
        return user
    }
    
    func logout() async throws {
        try tokenStorage.deleteToken()
        print("delete JWT token")
    }
    
    func isAuthenticated() -> Bool {
        return tokenStorage.isTokenValid()
    }
}
