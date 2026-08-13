//
//  SendFriendRequestUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 12.08.2026.
//

import Foundation

protocol SendFriendRequestUseCaseProtocol {
    func execute(userId: Int) async throws
}

final class SendFriendRequestUseCase: SendFriendRequestUseCaseProtocol {
    
    private let friendsRepository: FriendsRepositoryProtocol
    
    init(friendsRepository: FriendsRepositoryProtocol) {
        self.friendsRepository = friendsRepository
    }
    
    func execute(userId: Int) async throws {
        // Validate
        
        print("[Use Case]: send req")
        try await friendsRepository.sendFriendRequest(to: userId)
    }
}
