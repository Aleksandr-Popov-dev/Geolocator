//
//  SaveUserLocationUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 09.08.2026.
//

import Foundation

protocol SaveUserLocationUseCaseProtocol {
    func execute(location: Location) async throws
}

final class SaveUserLocationUseCase: SaveUserLocationUseCaseProtocol {
    
    private let locationRepository: LocationRepositoryProtocol
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    func execute(location: Location) async throws {
        try await locationRepository.updateLocation(location: location)
    }
}
