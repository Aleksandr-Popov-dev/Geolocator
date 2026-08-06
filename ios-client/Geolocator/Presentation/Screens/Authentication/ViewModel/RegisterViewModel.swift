//
//  RegisterViewModel.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 04.08.2026.
//

import SwiftUI
import Combine

@MainActor
final class RegisterViewModel: ObservableObject {
    // MARK: - UI State
    @Published var username: String = ""
    @Published var fullname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var registerSuccess: Bool = false
    
    // MARK: - Dependencies
    private let registerUserUseCase: RegisterUserUseCase
    private let onRegisterSuccess: (User) -> Void
    
    // MARK: - Init
    init (
        registerUserUseCase: RegisterUserUseCase,
        onRegisterSuccess: @escaping (User) -> Void
    ) {
        self.registerUserUseCase = registerUserUseCase
        self.onRegisterSuccess = onRegisterSuccess
    }
    
    // MARK: - Public Methods
    func register() async {
        guard !username.isEmpty || !fullname.isEmpty || !email.isEmpty || !password.isEmpty else {
            errorMessage = "Все поля должны быть заполнены"
            showError = true
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let user = try await registerUserUseCase.execute(
                username: username,
                fullname: fullname,
                email: email,
                password: password
            )
            
//            print("user register: \(username)")
            registerSuccess = true
            onRegisterSuccess(user)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        
    }
    
    // MARK: - Buttons Actions
    func registerButtonTapped() {
        Task {
            await register()
        }
    }
    
    @ViewBuilder
    var registerButtonLabel: some View {
        if isLoading {
            ProgressView()
                .progressViewStyle(.circular)
        } else {
            Text("Create account")
        }
    }
    
    
}
