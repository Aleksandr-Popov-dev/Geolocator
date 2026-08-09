//
//  LocationManger.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 06.08.2026.
//

import MapKit
import Combine

@MainActor
final class LocationManager: NSObject, LocationManagerProtocol {
    
    // MARK: - Published Properties
    @Published var currentLocation: Location?
    @Published var permissionStatus: LocationPermissionStatus = .notDetermined
    @Published var isTracking: Bool = false
    @Published var error: Error?
    
    var locationUpdates: AsyncStream<Location> {
        AsyncStream { continuation in
            self.locationStreamContinuation = continuation
            
            continuation.onTermination = { _ in
                Task { @MainActor in
                    self.locationStreamContinuation = nil
                }
            }
        }
    }
    
    // MARK: - Private Properties
    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<Location, Error>?
    private var permissionContinuation: CheckedContinuation<LocationPermissionStatus, Error>?
    private var locationStreamContinuation: AsyncStream<Location>.Continuation?
    
    // MARK: - Init
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        updatePermissionStatus()
    }
    
    // MARK: - Public Methods
    func requestPermission() async throws -> LocationPermissionStatus {
        return try await withCheckedThrowingContinuation { continuation in
            self.permissionContinuation = continuation
            
            if self.permissionStatus != .notDetermined {
                continuation.resume(returning: self.permissionStatus)
                self.permissionContinuation = nil
                return
            }
            
            self.manager.requestAlwaysAuthorization()
        }
    }
    
    func getCurrentLocation() async throws -> Location {
        guard permissionStatus == .allowed else {
            throw LocationError.permissionDenied
        }
        
        if let location = currentLocation {
            return location
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            self.manager.startUpdatingLocation()
            
            Task {
                try await Task.sleep(nanoseconds: 10_000_000_000)
                if self.locationContinuation != nil {
                    self.locationContinuation?.resume(throwing: LocationError.timeout)
                    self.locationContinuation = nil
                    self.manager.stopUpdatingLocation()
                }
            }
        }
    }
    
    func startTracking() async throws {
        guard permissionStatus == .allowed else {
            throw LocationError.permissionDenied
        }
        manager.startUpdatingLocation()
    }
    
    func stopTracking() {
        manager.stopUpdatingLocation()
    }
    
    // MARK: - Private Methods
    private func updatePermissionStatus() {
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            permissionStatus = .notDetermined
        case .authorizedWhenInUse, .authorizedAlways:
            permissionStatus = .allowed
        case .denied:
            permissionStatus = .denied
        case .restricted:
            permissionStatus = .restricted
        @unknown default:
            permissionStatus = .notDetermined
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updatePermissionStatus()
        
        if permissionStatus == .allowed {
            permissionContinuation?.resume(returning: .allowed)
            permissionContinuation = nil
            
            if !isTracking {
                Task {
                    try? await startTracking()
                }
            }
        }
        
        if permissionStatus == .denied || permissionStatus == .restricted {
            permissionContinuation?.resume(throwing: LocationError.permissionDenied)
            permissionContinuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let domainLocation = Location(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        currentLocation = domainLocation
        
        if let continuation = locationContinuation {
            continuation.resume(returning: domainLocation)
            locationContinuation = nil
            manager.stopUpdatingLocation()
        }
        
        locationStreamContinuation?.yield(domainLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error
        
        if let continuation = locationContinuation {
            continuation.resume(throwing: error)
            locationContinuation = nil
            manager.stopUpdatingLocation()
        }
        
        locationStreamContinuation?.finish()
    }
}


// MARK: - Errors
enum LocationError: LocalizedError {
    case permissionDenied
    case locationServicesDisabled
    case timeout
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Доступ к геолокации запрещён. Пожалуйста, разрешите доступ в настройках."
        case .locationServicesDisabled:
            return "Службы геолокации отключены. Включите их в настройках."
        case .timeout:
            return "Не удалось получить местоположение. Попробуйте позже."
        case .unknown:
            return "Произошла неизвестная ошибка"
        }
    }
}
