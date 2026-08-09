//
//  HomeView.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 04.08.2026.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if let location = viewModel.currentLocation {
                Map(initialPosition: .region(MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))) {
                    UserAnnotation()
                }
                .mapControls {
                    MapUserLocationButton()
                }
            } else {
                Text("Получение разрешения")
            }
            
        }
        .task {
            await viewModel.startTracking()
        }
        .alert("Ошибка", isPresented: $viewModel.showError) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
