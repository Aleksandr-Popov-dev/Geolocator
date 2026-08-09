//
//  HomeViewModel.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 04.08.2026.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    // MARK: - UI State
    @Published var user: User
    @Published var currentLocation: Location?
    @Published var permissionStatus: LocationPermissionStatus = .notDetermined
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Dependenciets
    private let requestRermissionUseCase: RequestPermissionUseCase
    private let getCurrentLocationUseCase: GetCurrentLocationUseCase
    private let startTrackingLocationUseCase: StartTrackingLocationUseCase
    private let updateUserLocationUseCase: UpdateUserLocationUseCase
    private let saveUserLocationUseCase: SaveUserLocationUseCase
    private var locationTask: Task<Void, Never>?
    
    // MARK: - Init
    init(
        user: User,
        requestRermissionUseCase: RequestPermissionUseCase,
        getCurrentLocationUseCase: GetCurrentLocationUseCase,
        startTrackingLocationUseCase: StartTrackingLocationUseCase,
        updateUserLocationUseCase: UpdateUserLocationUseCase,
        saveUserLocationUseCase: SaveUserLocationUseCase
    ) {
        self.user = user
        self.requestRermissionUseCase = requestRermissionUseCase
        self.getCurrentLocationUseCase = getCurrentLocationUseCase
        self.startTrackingLocationUseCase = startTrackingLocationUseCase
        self.updateUserLocationUseCase = updateUserLocationUseCase
        self.saveUserLocationUseCase = saveUserLocationUseCase
    }
    
    // MARK: - Public Methods
    func startTracking() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            permissionStatus = try await requestRermissionUseCase.execute()
            
            guard permissionStatus == .allowed else {
                errorMessage = "Разрешение на геолокацию не получено"
                showError = true
                return
            }
            
//            print("cur loc")
            locationTask = Task {
                for await location in updateUserLocationUseCase.execute() {
                    await MainActor.run {
                        self.currentLocation = location
                        self.isLoading = false
//                        print("[ViewModel] \(location.latitude), \(location.longitude)")
                    }
                    
                    do {
                        try await saveUserLocationUseCase.execute(location: location)
                    } catch {
                        await MainActor.run {
                            self.errorMessage = error.localizedDescription
                            self.showError = true
                        }
                    }
                }
            }
            
            try await startTrackingLocationUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
