//
//  GetPendingRequestsUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 13.08.2026.
//

import Foundation

protocol GetPendingRequestsUseCaseProtocol {
    func execute() async throws -> [FriendRequest]
}

final class GetPendingRequestsUseCase: GetPendingRequestsUseCaseProtocol {
    
    private let friendsRepository: FriendsRepositoryProtocol
    
    init(friendsRepository: FriendsRepositoryProtocol) {
        self.friendsRepository = friendsRepository
    }
    
    func execute() async throws -> [FriendRequest] {
        return try await friendsRepository.getPendingRequests()
    }
}
