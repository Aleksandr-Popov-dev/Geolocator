//
//  LocationDTOs.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 12.08.2026.
//

import Foundation

struct LocationRequestDTO: Encodable {
    let latitude: Double
    let longitude: Double
}


struct LocationResponseDTO: Decodable {
    let id: Int
    let user_id: Int
    let latitude: Double
    let longitude: Double
    
    func toDomain() -> Location {
        return Location(latitude: latitude, longitude: longitude)
    }
}
