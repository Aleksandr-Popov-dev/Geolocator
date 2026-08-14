//
//  AcceptFriendRequest.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 13.08.2026.
//

import Foundation

protocol AcceptFriendRequestUseCaseProtocol {
    func execute(_ friendshipId: Int) async throws
}

final class AcceptFriendRequestUseCase: AcceptFriendRequestUseCaseProtocol {
    
    private let friendsRepository: FriendsRepositoryProtocol
    
    init(friendsRepository: FriendsRepositoryProtocol) {
        self.friendsRepository = friendsRepository
    }
    
    func execute(_ friendshipId: Int) async throws {
        try await friendsRepository.acceptRequest(friendshipId)
    }
}
