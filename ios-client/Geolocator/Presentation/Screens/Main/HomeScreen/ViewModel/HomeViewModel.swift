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
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
}
