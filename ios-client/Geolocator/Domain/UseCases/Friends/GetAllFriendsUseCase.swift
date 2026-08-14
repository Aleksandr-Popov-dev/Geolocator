//
//  GetAllFriendsUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 14.08.2026.
//

import Foundation

protocol GetAllFriendsUseCaseProtocol {
    func execute() async throws -> [User]
}

final class GetAllFriendsUseCase: GetAllFriendsUseCaseProtocol {
    
    private let friendsRepository: FriendsRepositoryProtocol
    
    init(friendsRepository: FriendsRepositoryProtocol) {
        self.friendsRepository = friendsRepository
    }
    
    func execute() async throws -> [User] {
        return try await friendsRepository.getFriends()
    }
    
    
}
