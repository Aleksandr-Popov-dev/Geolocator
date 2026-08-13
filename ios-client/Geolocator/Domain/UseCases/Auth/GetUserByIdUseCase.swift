//
//  GetUserByIdUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 13.08.2026.
//

import Foundation

protocol GetUserByIdUseCaseProtocol {
    func execute(userId: Int) async throws -> User
}

final class GetUserByIdUseCase: GetUserByIdUseCaseProtocol {
    
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    func execute(userId: Int) async throws -> User {
        return try await authRepository.getUserById(userId: userId)
    }
}
