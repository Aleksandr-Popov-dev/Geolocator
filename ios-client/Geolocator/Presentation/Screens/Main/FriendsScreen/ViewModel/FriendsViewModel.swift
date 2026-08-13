//
//  FriendsViewModel.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 12.08.2026.
//

import Foundation
import Combine

@MainActor
class FriendsViewModel: ObservableObject {
    // MARK: - UI State
    @Published var pendingRequests: [FriendRequest] = []
    @Published var userId: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Dependenciets
    private let sendFriendRequestUseCase: SendFriendRequestUseCase
    private let getPendingRequestsUseCase: GetPendingRequestsUseCase
    
    
    // MARK: - Init
    init (
        sendFriendRequestUseCase: SendFriendRequestUseCase,
        getPendingRequestsUseCase: GetPendingRequestsUseCase
    ) {
        self.sendFriendRequestUseCase = sendFriendRequestUseCase
        self.getPendingRequestsUseCase = getPendingRequestsUseCase
    }
    
    // MARK: - Public Methods
    func sendFriendRequest() async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            print("[viewModel]: send req")
            try await sendFriendRequestUseCase.execute(userId: Int(userId) ?? 0)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    func loadPendingRequests() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let requests = try await getPendingRequestsUseCase.execute()
            print("[ViewModel] count \(requests.count) req")
            pendingRequests = requests
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    // MARK: - Button Actions
    func sendFriendRequestButtonTapped() {
        Task {
            do {
                try await sendFriendRequest()
            }
        }
    }
}
