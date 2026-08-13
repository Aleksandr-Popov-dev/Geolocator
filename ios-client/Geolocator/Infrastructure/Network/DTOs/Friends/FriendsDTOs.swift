//
//  FriendsDTOs.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 13.08.2026.
//

import Foundation

struct SendFriendRequestRequestDTO: Encodable {
    let user_id: Int
}

struct FriendsResponseDTO: Decodable {
    let id: Int
    let sender_id: Int
    let receiver_id: Int
    let status: String
    
    func toDomain() -> FriendRequest {
        return FriendRequest(
            id: id,
            senderId: sender_id,
            receiverId: receiver_id,
            status: FriendRequestStatus(rawValue: status) ?? .pending,
            sender: nil,
            receiver: nil
        )
    }
}
