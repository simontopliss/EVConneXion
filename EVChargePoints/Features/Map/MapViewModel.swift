//
//  MapViewModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 23/07/2023.
//

import SwiftUI
import MapKit

final class MapViewModel: ObservableObject {
    
    // TODO: This needs to be stored and read from UserDefaults if we've been given permission to get the user's location
    @Published var userLocation: CLLocationCoordinate2D = LocationManager.defaultLocation
    @Published var region: MKCoordinateRegion = LocationManager.defaultRegion

    init() {
        //self.userLocation = .defaultLocation
    }

}
