//
//  LocationManagerProtocol.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 06.08.2026.
//

import MapKit

protocol LocationManagerProtocol {
    var currentLocation: Location? { get }
    var permissionStatus: LocationPermissionStatus { get }
    var locationUpdates: AsyncStream<Location> { get }
    func requestPermission() async throws -> LocationPermissionStatus
    func getCurrentLocation() async throws -> Location
    func startTracking() async throws
    func stopTracking()
}
