//
//  AppDIContainer.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 04.08.2026.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - Infrastructure
    private lazy var networkService: NetworkServiceProtocol = {
        let baseURL = "http://localhost:8000"
        let tokenStorage = self.tokenStorage
        return NetworkService(baseURL: baseURL, tokenStorage: tokenStorage)
    }()
    
    private lazy var tokenStorage: TokenStorageProtocol = {
        return KeychainTokenStorage()
    }()
    
    // MARK: - Repositories
    private lazy var authRepository: AuthRepositoryProtocol = {
        return AuthRepository(
            networkService: networkService,
            tokenStorage: tokenStorage
        )
    }()
    
    // MARK: - Use Cases
    private lazy var registerUserUseCase: RegisterUserUseCase = {
        return RegisterUserUseCase(authRepository: authRepository)
    }()
    
    private lazy var loginUserUseCase: LoginUserUseCase = {
        return LoginUserUseCase(authRepository: authRepository)
    }()
    
    // MARK: - View Models
    func makeRegisterViewModel(onRegisterSuccess: @escaping (User) -> Void) -> RegisterViewModel {
        return RegisterViewModel(
            registerUserUseCase: registerUserUseCase,
            onRegisterSuccess: onRegisterSuccess
        )
    }
    
    func makeLoginViewModel(onLoginSuccess: @escaping (User) -> Void, goToRegister: @escaping () -> Void) -> LoginViewModel {
        return LoginViewModel(
            loginUserUseCase: loginUserUseCase,
            onLoginSuccess: onLoginSuccess,
            goToRegister: goToRegister
        )
    }
    
    func makeHomeViewModel(user: User) -> HomeViewModel {
        return HomeViewModel(user: user)
    }
    
}
