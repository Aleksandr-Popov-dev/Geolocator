//
//  LoginView.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 08.07.2026.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Login")
                .font(.largeTitle)
            VStack(alignment: .leading, spacing: 10) {
                TextField("email", text: $viewModel.email)
                Divider()
                TextField("password", text: $viewModel.password)
                Divider()
            }
            .padding(.horizontal)
            .font(.title2)
            
            Button {
                viewModel.loginButtonTapped()
            } label: {
                viewModel.loginButtonLabel
            }
            .font(.title)
            
            Spacer()
            
            HStack {
                Text("Don't have an account?")
                
                Button {
                    viewModel.goToRegisterTapped()
                } label: {
                    Text("Register")
                }
            }
            .font(.body)
            .padding(.bottom)
            
        }
        .alert("Ошибка", isPresented: $viewModel.showError) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

