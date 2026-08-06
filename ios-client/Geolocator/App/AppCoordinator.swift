//
//  AppCoordinator.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 04.08.2026.
//

import SwiftUI
import Combine

enum AppScreen {
    case register
    case login
    case home
}

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var currentScreen: AppScreen = .login
    
    private let container = AppDIContainer()
    private var currentUser: User?

    // MARK: - Navigation Methods
    func navigateToHome(user: User) {
        currentUser = user
        currentScreen = .home
    }
    
    func navigateToRegister() {
        currentScreen = .register
    }
    
    func navigateToLogin() {
        currentScreen = .login
    }
    
    // MARK: - View Builders
    @ViewBuilder
    func buildLoginView() -> some View {
        let viewModel = container.makeLoginViewModel(
            onLoginSuccess: { [weak self] user in
                self?.navigateToHome(user: user)
            },
            goToRegister: { [weak self] in
                self?.navigateToRegister()
            }
        )
        LoginView(viewModel: viewModel)
    }
    
    @ViewBuilder
    func buildRegisterView() -> some View {
        let viewModel = container.makeRegisterViewModel(
            onRegisterSuccess: { [weak self] user in
                self?.navigateToHome(user: user)
            }
        )
        RegisterView(viewModel: viewModel)
    }
    
    @ViewBuilder
    func buildHomeView() -> some View {
        if let user = currentUser {
            let viewModel = container.makeHomeViewModel(user: user)
            HomeView(viewModel: viewModel)
        } else {
            buildRegisterView()
        }
    }

    
}
