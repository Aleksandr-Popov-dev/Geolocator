//
//  LocationRepository.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 06.08.2026.
//

import Foundation

final class LocationRepository: LocationRepositoryProtocol {
    
    private let locationManager: LocationManagerProtocol
    
    init(locationManager: LocationManagerProtocol) {
        self.locationManager = locationManager
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
