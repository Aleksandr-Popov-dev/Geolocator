//
//  FriendsView.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 12.08.2026.
//

import SwiftUI

struct FriendsView: View {
    
    @StateObject private var viewModel: FriendsViewModel
    
    init(viewModel: FriendsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            TextField("userId", text: $viewModel.userId)
            Button("send") {
                viewModel.sendFriendRequestButtonTapped()
            }
            List {
                if viewModel.pendingRequests.isEmpty {
                    Text("Нет входящих запросов")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(viewModel.pendingRequests, id:\.id) { request in
                        Text("запрос на добавление в друзья от: \(request.sender?.fullname ?? "Unknown")")
                    }
                }
            }
            .refreshable {
                await viewModel.loadPendingRequests()
            }
        }
        .task {
            await viewModel.loadPendingRequests()
        }
        .alert("Ошибка", isPresented: $viewModel.showError) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }

    }
}

