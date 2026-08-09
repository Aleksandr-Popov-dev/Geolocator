//
//  RequestTracingLocationUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 06.08.2026.
//

import Foundation

protocol RequestPermissionUseCaseProtocol {
    func execute() async throws -> LocationPermissionStatus
}


final class RequestPermissionUseCase: RequestPermissionUseCaseProtocol {
    
    private let locationRepository: LocationRepositoryProtocol
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    func execute() async throws -> LocationPermissionStatus {
        try await locationRepository.requestPermission()
    }
}
