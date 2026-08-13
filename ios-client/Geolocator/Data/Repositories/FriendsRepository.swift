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
        let response: FriendsResponseDTO = try await networkService.request(endpoint)
        print("send frind req status: \(response.toDomain())")
    }
    
    func getPendingRequests() async throws -> [FriendRequest] {
        let endpoint = APIEndpoints.getPengingRequests()
        let response: [FriendsResponseDTO] = try await networkService.request(endpoint)
        return response.map { $0.toDomain() }
    }
    
    func acceptRequest(_ requestId: Int) async throws {
        //
    }
    
    func rejectRequest(_ requestId: Int) async throws {
        //
    }
    
    func getFriends() async throws -> [User] {
        let users = [User(id: "0", username: "n", fullname: "f", email: "e")]
        return users
    }
    
    func checkFriendship(with userId: Int) async throws -> Bool {
        return true
    }
    
    
}
