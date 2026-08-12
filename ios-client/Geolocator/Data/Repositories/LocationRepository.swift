//
//  LocationRepository.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 06.08.2026.
//

import Foundation

final class LocationRepository: LocationRepositoryProtocol {
    
    private let locationManager: LocationManagerProtocol
    private let networkService: NetworkServiceProtocol
    
    init(locationManager: LocationManagerProtocol, networkService: NetworkServiceProtocol) {
        self.locationManager = locationManager
        self.networkService = networkService
    }
    
    func requestPermission() async throws -> LocationPermissionStatus {
        try await locationManager.requestPermission()
    }
    
    func getCurrentLocation() async throws -> Location {
        try await locationManager.getCurrentLocation()
    }
    
    func startTracking() async throws {
        try await locationManager.startTracking()
    }
    
    func stopTracking() {
        locationManager.stopTracking()
    }
    
    // MARK: - Network
    func updateLocation(location: Location) async throws {
        let endpoint = APIEndpoints.updateLocation(location: location)
        
        let response: LocationResponseDTO = try await networkService.request(endpoint)
        let loc = response.toDomain()
        print("loc: \(loc)")
    }
    
    // MARK: - State
    var currentLocation: Location? {
        locationManager.currentLocation
    }
    
    var locationUpdates: AsyncStream<Location> {
        locationManager.locationUpdates
    }
    
    var permissionStatus: LocationPermissionStatus {
        locationManager.permissionStatus
    }
}
