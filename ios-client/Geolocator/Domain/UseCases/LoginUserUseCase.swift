//
//  LoginUserUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 05.08.2026.
//

import Foundation

protocol LoginUserUseCaseProtocol {
    func execute(email: String, password: String) async throws -> User
}


final class LoginUserUseCase: LoginUserUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String) async throws -> User {
        guard password.count >= 4 else {
            throw ValidationError.weakPassword
        }
        
        guard !email.isEmpty else {
            throw ValidationError.invalidEmail
        }
        
        return try await authRepository.login(
            email: email,
            password: password
        )
    }
    
    
}
