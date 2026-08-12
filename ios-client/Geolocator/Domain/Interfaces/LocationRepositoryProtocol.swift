//
//  LocationRepositoryProtocol.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 06.08.2026.
//

import Foundation

protocol LocationRepositoryProtocol {
    func requestPermission() async throws -> LocationPermissionStatus
    func getCurrentLocation() async throws -> Location
    func startTracking() async throws
    func stopTracking()
    
    // MARK: - Network
    func updateLocation(location: Location) async throws
    
    // MARK: - State
    var currentLocation: Location? { get }
    var locationUpdates: AsyncStream<Location> { get }
    var permissionStatus: LocationPermissionStatus { get }
}
