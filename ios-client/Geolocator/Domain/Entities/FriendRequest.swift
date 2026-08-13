//
//  FriendRequest.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 13.08.2026.
//

import Foundation

struct FriendRequest {
    let id: Int
    let senderId: Int
    let receiverId: Int
    let status: FriendRequestStatus
}
