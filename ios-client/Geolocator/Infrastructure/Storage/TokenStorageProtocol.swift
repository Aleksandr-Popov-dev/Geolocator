//
//  TokenStorageProtocol.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 05.08.2026.
//

import Foundation

protocol TokenStorageProtocol {
    func saveToken(_ token: String) throws
    func getToken() throws -> String?
    func deleteToken() throws
    func isTokenValid() -> Bool
}
