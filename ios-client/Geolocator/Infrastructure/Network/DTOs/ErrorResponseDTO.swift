//
//  ErrorResponseDTO.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 05.08.2026.
//


struct ErrorResponseDTO: Decodable {
    let error: String
    let message: String
}