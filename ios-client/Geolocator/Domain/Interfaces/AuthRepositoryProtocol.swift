//
//  AuthRepositoryProtocol.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 03.08.2026.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> User
    
    func register(username: String, fullname: String, email: String, password: String) async throws -> User
    
    func logout() async throws
}
