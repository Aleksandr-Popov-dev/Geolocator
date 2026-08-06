//
//  HomeView.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 04.08.2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello \(viewModel.user.fullname)")
    }
}
