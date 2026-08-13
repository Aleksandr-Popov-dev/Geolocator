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
    
    private lazy var locationManager: LocationManagerProtocol = {
        return LocationManager()
    }()
    
    // MARK: - Repositories
    private lazy var authRepository: AuthRepositoryProtocol = {
        return AuthRepository(
            networkService: networkService,
            tokenStorage: tokenStorage
        )
    }()
    
    private lazy var locationRepository: LocationRepositoryProtocol = {
        return LocationRepository(
            locationManager: locationManager,
            networkService: networkService
        )
    }()
    
    private lazy var friendsRepository: FriendsRepositoryProtocol = {
        return FriendsRepository(networkService: networkService)
    }()
    
    // MARK: - Use Cases
    private lazy var registerUserUseCase: RegisterUserUseCase = {
        return RegisterUserUseCase(authRepository: authRepository)
    }()
    
    private lazy var loginUserUseCase: LoginUserUseCase = {
        return LoginUserUseCase(authRepository: authRepository)
    }()
    
    private lazy var requestPermissionUseCase: RequestPermissionUseCase = {
        return RequestPermissionUseCase(locationRepository: locationRepository)
    }()
    
    private lazy var getCurrentLocationUseCase: GetCurrentLocationUseCase = {
        return GetCurrentLocationUseCase(locationRepository: locationRepository)
    }()
    
    private lazy var startTrackingLocationUseCase: StartTrackingLocationUseCase = {
        return StartTrackingLocationUseCase(locationRepository: locationRepository)
    }()
    
    private lazy var updateUserLocationUseCase: UpdateUserLocationUseCase = {
        return UpdateUserLocationUseCase(locationRepository: locationRepository)
    }()
    
    private lazy var saveUserLocationUseCase: SaveUserLocationUseCase = {
        return SaveUserLocationUseCase(locationRepository: locationRepository)
    }()
    
    private lazy var sendFriendRequestUseCase: SendFriendRequestUseCase = {
        return SendFriendRequestUseCase(friendsRepository: friendsRepository)
    }()
    
    private lazy var getPendingRequestsUseCase: GetPendingRequestsUseCase = {
        return GetPendingRequestsUseCase(friendsRepository: friendsRepository)
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
    
    func makeHomeViewModel(user: User, goToFriendsView: @escaping () -> Void) -> HomeViewModel {
        return HomeViewModel(
            user: user,
            requestRermissionUseCase: requestPermissionUseCase,
            getCurrentLocationUseCase: getCurrentLocationUseCase,
            startTrackingLocationUseCase: startTrackingLocationUseCase,
            updateUserLocationUseCase: updateUserLocationUseCase,
            saveUserLocationUseCase: saveUserLocationUseCase,
            goToFriendsView: goToFriendsView
        )
    }
    
    func makeFriendsViewModel() -> FriendsViewModel {
        return FriendsViewModel(
            sendFriendRequestUseCase: sendFriendRequestUseCase,
            getPendingRequestsUseCase: getPendingRequestsUseCase
        )
    }
    
}
