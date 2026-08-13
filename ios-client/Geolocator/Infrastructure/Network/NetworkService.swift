//
//  NetworkService.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 04.08.2026.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    private let baseURL: String
    private let session: URLSession
    private let tokenStorage: TokenStorageProtocol
    
    init(baseURL: String, session: URLSession = .shared, tokenStorage: TokenStorageProtocol) {
        self.baseURL = baseURL
        self.session = session
        self.tokenStorage = tokenStorage
    }
    
    func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        guard let url = buildURL(for: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = try? tokenStorage.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            print("token in request")
        }
        
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let body = endpoint.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
//            let rawString = String(data: data, encoding: .utf8) ?? "nil"
//                print("📄 Raw JSON: \(rawString)")
//            
//            do {
//                let decoder = JSONDecoder()
//                let decoded = try decoder.decode(T.self, from: data)
//                print("✅ Декодировано успешно: \(decoded)")
//                return decoded
//            } catch {
//                print("❌ Ошибка декодирования: \(error)")
//                print("📄 Проблемный JSON: \(rawString)")
//                throw NetworkError.decodingError(error)
//            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return try JSONDecoder().decode(T.self, from: data)
            case 400...499:
                let errorResponse = try JSONDecoder().decode(ErrorResponseDTO.self, from: data)
                throw NetworkError.clientError(errorResponse.message)
            case 500...599:
                throw NetworkError.serverError
            default:
                throw NetworkError.unknown
            }
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        } catch {
            throw NetworkError.networkError(error)
        }
        
    }
    
    private func buildURL(for endpoint: Endpoint) -> URL? {
        var components = URLComponents(string: baseURL + endpoint.path)
        
        if let queryItems = endpoint.queryItems {
            components?.queryItems = queryItems
        }
        return components?.url
        
    }
}


// MARK: - Errors
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case clientError(String)
    case serverError
    case networkError(Error)
    case decodingError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .invalidResponse:
            return "Неверный ответ сервера"
        case .clientError(let message):
            return message
        case .serverError:
            return "Ошибка на сервере"
        case .networkError(let error):
            return "Ошибка сети: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Ошибка обработки данных: \(error.localizedDescription)"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}
