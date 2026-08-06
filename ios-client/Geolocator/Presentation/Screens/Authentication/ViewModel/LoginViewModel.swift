//
//  LoginViewModel.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 05.08.2026.
//

import SwiftUI
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    // MARK: - UI State
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var loginSuccess: Bool = false
    
    // MARK: - Dependencies
    private let loginUserUseCase: LoginUserUseCase
    private let onLoginSuccess: (User) -> Void
    private let goToRegister: () -> Void
    
    // MARK: - Init
    init(
        loginUserUseCase: LoginUserUseCase,
        onLoginSuccess: @escaping (User) -> Void,
        goToRegister: @escaping () -> Void
    ) {
        self.loginUserUseCase = loginUserUseCase
        self.onLoginSuccess = onLoginSuccess
        self.goToRegister = goToRegister
    }
    
    // MARK: - Public Methods
    func login() async {
        guard !email.isEmpty || !password.isEmpty else {
            errorMessage = "Все поля должны быть заполнены"
            showError = true
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let user = try await loginUserUseCase.execute(
                email: email,
                password: password
            )
            
            loginSuccess = true
            onLoginSuccess(user)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    // MARK: - Button Actions
    func loginButtonTapped() {
        Task {
            await login()
        }
    }
    
    @ViewBuilder
    var loginButtonLabel: some View {
        if isLoading {
            ProgressView()
                .progressViewStyle(.circular)
        } else {
            Text("login")
        }
    }
    
    func goToRegisterTapped() {
        goToRegister()
    }
}
