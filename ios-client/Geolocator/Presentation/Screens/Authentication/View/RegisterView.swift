//
//  RegisterView.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 08.07.2026.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel: RegisterViewModel
    
    init(viewModel: RegisterViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
            VStack(alignment: .leading, spacing: 10) {
                TextField("fullname", text: $viewModel.fullname)
                Divider()
                TextField("username", text: $viewModel.username)
                Divider()
                TextField("email", text: $viewModel.email)
                Divider()
                TextField("password", text: $viewModel.password)
                Divider()
            }
            .padding(.horizontal)
            .font(.title2)
            
            HStack {
                Button {
                    viewModel.registerButtonTapped()
                } label: {
                    viewModel.registerButtonLabel
                }
            }
            .font(.title)
        }
        .alert("Ошибка", isPresented: $viewModel.showError) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
