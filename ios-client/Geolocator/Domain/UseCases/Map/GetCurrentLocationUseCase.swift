//
//  GetCurrentLocationUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 07.08.2026.
//

import Foundation

protocol GetCurrentLocationUseCaseProtocol {
    func execute() async throws -> Location
}

final class GetCurrentLocationUseCase: GetCurrentLocationUseCaseProtocol {
    
    private let locationRepository: LocationRepositoryProtocol
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    func execute() async throws -> Location {
        try await locationRepository.getCurrentLocation()
    }
    
    
}
