//
//  GeolocatorApp.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 08.07.2026.
//

import SwiftUI

@main
struct GeolocatorApp: App {
    @StateObject private var coordinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            Group {
                switch coordinator.currentScreen {
                case .register:
                    coordinator.buildRegisterView()
                case .login:
                    coordinator.buildLoginView()
                case .home:
                    coordinator.buildHomeView()
                case .friends:
                    coordinator.buildFriendView()
                }
            }
        }
    }
}
