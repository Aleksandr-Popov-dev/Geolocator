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
    @Published var pendingRequests: [FriendRequest] = []
    @Published var friends: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Dependenciets
    private let requestRermissionUseCase: RequestPermissionUseCase
    private let getCurrentLocationUseCase: GetCurrentLocationUseCase
    private let startTrackingLocationUseCase: StartTrackingLocationUseCase
    private let updateUserLocationUseCase: UpdateUserLocationUseCase
    private let saveUserLocationUseCase: SaveUserLocationUseCase
    
    private let getPendingRequestsUseCase: GetPendingRequestsUseCase
    private let getUserByIdUseCase: GetUserByIdUseCase
    private let acceptFriendRequestUseCase: AcceptFriendRequestUseCase
    private let rejectFriendRequestUseCase: RejectFriendRequestUseCase
    private let getAllFriendsUseCase: GetAllFriendsUseCase
    
    private var locationTask: Task<Void, Never>?
    private let goToFriendsView: () -> Void
    
    // MARK: - Init
    init(
        user: User,
        requestRermissionUseCase: RequestPermissionUseCase,
        getCurrentLocationUseCase: GetCurrentLocationUseCase,
        startTrackingLocationUseCase: StartTrackingLocationUseCase,
        updateUserLocationUseCase: UpdateUserLocationUseCase,
        saveUserLocationUseCase: SaveUserLocationUseCase,
        acceptFriendRequestUseCase: AcceptFriendRequestUseCase,
        getPendingRequestsUseCase: GetPendingRequestsUseCase,
        getUserByIdUseCase: GetUserByIdUseCase,
        rejectFriendRequestUseCase: RejectFriendRequestUseCase,
        getAllFriendsUseCase: GetAllFriendsUseCase,
        goToFriendsView: @escaping () -> Void
    ) {
        self.user = user
        self.requestRermissionUseCase = requestRermissionUseCase
        self.getCurrentLocationUseCase = getCurrentLocationUseCase
        self.startTrackingLocationUseCase = startTrackingLocationUseCase
        self.updateUserLocationUseCase = updateUserLocationUseCase
        self.saveUserLocationUseCase = saveUserLocationUseCase
        self.acceptFriendRequestUseCase = acceptFriendRequestUseCase
        self.getPendingRequestsUseCase = getPendingRequestsUseCase
        self.getUserByIdUseCase = getUserByIdUseCase
        self.rejectFriendRequestUseCase = rejectFriendRequestUseCase
        self.getAllFriendsUseCase = getAllFriendsUseCase
        
        self.goToFriendsView = goToFriendsView
        
        Task {
            await startTracking()
            await loadPendingRequests()
            await loadFriends()
        }
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
            
            locationTask = Task {
                for await location in updateUserLocationUseCase.execute() {
                    await MainActor.run {
                        self.currentLocation = location
                        self.isLoading = false
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
    
//    func sendFriendRequest() async throws {
//        isLoading = true
//        defer { isLoading = false }
//        
//        do {
//            try await sendFriendRequestUseCase.execute(userId: Int(userId) ?? 0)
//        } catch {
//            errorMessage = error.localizedDescription
//            showError = true
//        }
//    }
    
    func loadPendingRequests() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let requests = try await getPendingRequestsUseCase.execute()
            pendingRequests = requests
            for index in pendingRequests.indices {
                let request = pendingRequests[index]
                let user = await getUser(userId: request.senderId)
                pendingRequests[index].sender = user ?? nil
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    func loadFriends() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let friendsResponse = try await getAllFriendsUseCase.execute()
            friends = friendsResponse
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    // MARK: - Private Methods
    func getUser(userId: Int) async -> User? {
        do {
            let user = try await getUserByIdUseCase.execute(userId: userId)
            return user
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            return nil
        }
    }

    
    // MARK: - Button Actions
    func goToFriendViewButtonTapped() {
        goToFriendsView()
    }
}
