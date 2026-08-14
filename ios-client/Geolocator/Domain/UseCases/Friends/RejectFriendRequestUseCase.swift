//
//  RejectFriendRequestUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 14.08.2026.
//

import Foundation

protocol RejectFriendRequestUseCaseProtocol {
    func execute(friendshipId: Int) async throws
}

final class RejectFriendRequestUseCase: RejectFriendRequestUseCaseProtocol {
    
    private let friendsRepository: FriendsRepositoryProtocol
    
    init(friendsRepository: FriendsRepositoryProtocol) {
        self.friendsRepository = friendsRepository
    }
    
    func execute(friendshipId: Int) async throws {
        try await friendsRepository.rejectRequest(friendshipId)
    }
    
    
}
