//
//  Location.swift
//  Geolocator
//
//  Created by Popov Alexsandr on 06.08.2026.
//

import MapKit

struct Location {
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
