//
//  StartUpdatingLocationUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 07.08.2026.
//

import Foundation

protocol StartTrackingLocationUseCaseProtocol {
    func execute() async throws
}

final class StartTrackingLocationUseCase: StartTrackingLocationUseCaseProtocol {
    
    private let locationRepository: LocationRepositoryProtocol
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    func execute() async throws {
        try await locationRepository.startTracking()
    }
    
    
}
