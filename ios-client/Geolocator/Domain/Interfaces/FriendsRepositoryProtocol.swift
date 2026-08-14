//
//  FriendsRepositoryProtocol.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 12.08.2026.
//

import Foundation

protocol FriendsRepositoryProtocol {
    func sendFriendRequest(to userId: Int) async throws
    
    func getPendingRequests() async throws -> [FriendRequest]
    
    func acceptRequest(_ friendshipId: Int) async throws
    
    func rejectRequest(_ friendshipId: Int) async throws
    
    func getFriends() async throws -> [User]
    
    func checkFriendship(with userId: Int) async throws -> Bool
}
