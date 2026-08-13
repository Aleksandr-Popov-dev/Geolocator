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
    private let getUserByIdUseCase: GetUserByIdUseCase
    
    // MARK: - Init
    init (
        sendFriendRequestUseCase: SendFriendRequestUseCase,
        getPendingRequestsUseCase: GetPendingRequestsUseCase,
        getUserByIdUseCase: GetUserByIdUseCase
    ) {
        self.sendFriendRequestUseCase = sendFriendRequestUseCase
        self.getPendingRequestsUseCase = getPendingRequestsUseCase
        self.getUserByIdUseCase = getUserByIdUseCase
    }
    
    // MARK: - Public Methods
    func sendFriendRequest() async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
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
            pendingRequests = requests
            for index in pendingRequests.indices {
                let request = pendingRequests[index]
                let user = await getUser(userId: request.senderId)
                pendingRequests[index].sender = user ?? nil
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    // MARK: - Private Methods
    func getUser(userId: Int) async -> User? {
        do {
            let user = try await getUserByIdUseCase.execute(userId: userId)
            return user
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            return nil
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
