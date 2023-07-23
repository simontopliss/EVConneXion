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
    @Published var userLocation: CLLocationCoordinate2D = .defaultLocation
    @Published var region: MKCoordinateRegion = .defaultRegion

    // TODO: Store in UserDefaults
    @Published var cameraHeight: CLLocationDistance = 2500 // Distance in metres

    init() {
        //self.userLocation = .defaultLocation
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
            latitudinalMeters: cameraHeight,
            longitudinalMeters: cameraHeight
        )

        return deviceLocation
    }

}
