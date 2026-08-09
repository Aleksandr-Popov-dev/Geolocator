//
//  RegisterUserUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 03.08.2026.
//

import Foundation

protocol RegisterUserUseCaseProtocol {
    func execute(username: String, fullname: String, email: String, password: String) async throws -> User
}


final class RegisterUserUseCase: RegisterUserUseCaseProtocol {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    func execute(username: String, fullname: String, email: String, password: String) async throws -> User {
        
        // MOVE TO VALIDATOR
        guard password.count >= 4 else {
            throw ValidationError.weakPassword
        }
        
        guard !username.isEmpty else {
            throw ValidationError.empty
        }
        
        guard !fullname.isEmpty else {
            throw ValidationError.empty
        }
        
        return try await authRepository.register(
            username: username,
            fullname: fullname,
            email: email,
            password: password
        )

    }
}


enum ValidationError: LocalizedError {
    case invalidEmail
    case weakPassword
    case empty
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Введите корректный email"
        case .weakPassword:
            return "Пароль должен содержать минимум 4 символов"
        case .empty:
            return "Все поля должны быть заполнены"
        }
    }
}
