//
//  KeychainTokenStorage.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 06.08.2026.
//

import Foundation

final class KeychainTokenStorage: TokenStorageProtocol {
    
    private let service = "com.geolocator.token"
    private let account = "jwt_token"

    func saveToken(_ token: String) throws {
        guard let tokenData = token.data(using: .utf8) else {
            throw TokenStorageError.invalidData
        }
        
        try? deleteToken()
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: tokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            throw TokenStorageError.saveFailed(status)
        }
    }
    
    func getToken() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            return nil
        }
        
        guard status == errSecSuccess else {
            throw TokenStorageError.loadFailed(status)
        }
        
        guard let tokenData = result as? Data,
              let token = String(data: tokenData, encoding: .utf8) else {
            throw TokenStorageError.invalidData
        }
        
        return token
    }
    
    func deleteToken() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            throw TokenStorageError.deleteFailed(status)
        }
    }
    
    func isTokenValid() -> Bool {
        guard let token = try? getToken() else {
            return false
        }
        
        return !token.isEmpty
    }
}


// MARK: - Errors
enum TokenStorageError: LocalizedError {
    case invalidData
    case saveFailed(OSStatus)
    case loadFailed(OSStatus)
    case deleteFailed(OSStatus)
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Неверный формат токена"
        case .saveFailed(let status):
            return "Ошибка сохранения токена: \(status)"
        case .loadFailed(let status):
            return "Ошибка загрузки токена: \(status)"
        case .deleteFailed(let status):
            return "Ошибка удаления токена: \(status)"
        }
    }
}
