//
//  MapViewModel.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 23/07/2023.
//

import SwiftUI
import MapKit

final class MapViewModel: ObservableObject {
    
    @Published var userLocation: CLLocationCoordinate2D?
    
    init() {
        // TODO: This needs to be stored and read from UserDefaults if we've been given permission to get the user's location
        self.userLocation = userLocation
    }

    func coordinateFor(_ chargeDeviceLocation: ChargeDeviceLocation) -> CLLocationCoordinate2D? {
        guard let latitude = Double(chargeDeviceLocation.latitude),
              let longitude = Double(chargeDeviceLocation.longitude) else {
            return nil
        }

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func regionFor(_ chargeDeviceLocation: ChargeDeviceLocation) -> MKCoordinateRegion? {

        guard let locationCoordinate = coordinateFor(chargeDeviceLocation) else { return nil }

        let deviceLocation = MKCoordinateRegion(
            center: locationCoordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )

        return deviceLocation
    }

}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        // TODO: Is this a good default location?
        // London Eye
        return .init(latitude: 51.503351, longitude: -0.119623)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(
            center: .userLocation,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
    }
}
