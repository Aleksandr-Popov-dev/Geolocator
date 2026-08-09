//
//  UpdateUserLocationUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 09.08.2026.
//

import Foundation

protocol UpdateUserLocationUseCaseProtocol {
    func execute() -> AsyncStream<Location>
    func stopTracking()
}

final class UpdateUserLocationUseCase: UpdateUserLocationUseCaseProtocol {
    
    private let locationRepository: LocationRepositoryProtocol
    private var continuation: AsyncStream<Location>.Continuation?
    private var isActive: Bool = false
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    func execute() -> AsyncStream<Location> {
        return AsyncStream(Location.self, bufferingPolicy: .unbounded) { continuation in
            self.continuation = continuation
            
            continuation.onTermination = { _ in
                Task { @MainActor in
                    self.stopTracking()
                }
            }
            
            Task {
                do {
                    try await self.locationRepository.startTracking()
                    self.isActive = true
                    
                    for await location in self.locationRepository.locationUpdates {
                        continuation.yield(location)
                        print("[Use Case]: newloc: \(location)")
                    }
                } catch {
                    continuation.finish()
                }
            }
        }
    }
    
    
    func stopTracking() {
        guard isActive else { return }
        
        isActive = false
        locationRepository.stopTracking()
        continuation?.finish()
        continuation = nil
        print("[UseCase] Отслеживание остановлено")

    }
    
}
