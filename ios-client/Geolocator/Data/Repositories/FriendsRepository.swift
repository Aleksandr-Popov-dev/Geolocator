//
//  FriendsRepository.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 12.08.2026.
//

import Foundation

final class FriendsRepository: FriendsRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func sendFriendRequest(to userId: Int) async throws {
        print("[Rep] get endpoint")
        let endpoint = APIEndpoints.sendFriendRequest(user_id: userId)
        print("[Rep] response")
        let response: FriendsRequestsResponseDTO = try await networkService.request(endpoint)
        print("send frind req status: \(response.toDomain())")
    }
    
    func getPendingRequests() async throws -> [FriendRequest] {
        let endpoint = APIEndpoints.getPengingRequests()
        let response: [FriendsRequestsResponseDTO] = try await networkService.request(endpoint)
        return response.map { $0.toDomain() }
    }
    
    func acceptRequest(_ friendshipId: Int) async throws {
        let endpoint = APIEndpoints.acceptFriendRequest(friendshipId: friendshipId)
        let response: FriendsRequestsResponseDTO = try await networkService.request(endpoint)
    }
    
    func rejectRequest(_ friendshipId: Int) async throws {
        let endpoint = APIEndpoints.rejectFriendRequest(friendshipId: friendshipId)
        let response: FriendsRequestsResponseDTO = try await networkService.request(endpoint)
    }
    
    func getFriends() async throws -> [User] {
        let endpoint = APIEndpoints.getAllFriends()
        let response: [FriendsResponseDTO] = try await networkService.request(endpoint)
        var friends: [User] = []
        for friend in response {
            friends.append(friend.toDomain())
        }
        return friends
    }
    
    func checkFriendship(with userId: Int) async throws -> Bool {
        return true
    }
    
    
}
