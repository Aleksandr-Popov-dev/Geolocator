//
//  SaveUserLocationUseCase.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 09.08.2026.
//

import Foundation

protocol SaveUserLocationUseCaseProtocol {
    func execute(location: Location) async throws
}

final class SaveUserLocationUseCase: SaveUserLocationUseCaseProtocol {
    
    
    func execute(location: Location) async throws {
        print("save location: \(location)")
    }
}
