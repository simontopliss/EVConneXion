//
//  DeviceMapItem.swift
//  EVConneXion
//
//  Created by Simon Topliss on 27/07/2023.
//

import MapKit
import SwiftUI

struct DeviceMapItem {

    var coordinate: CLLocationCoordinate2D
    var mapItem: MKMapItem
    var region: MKCoordinateRegion

    init(
        latitude: Double,
        longitude: Double
    ) {
        coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        mapItem = MKMapItem(placemark: .init(coordinate: coordinate))
        region = .init(
            center: coordinate,
            latitudinalMeters: .cameraHeight,
            longitudinalMeters: .cameraHeight
        )
    }

    func distanceFromUser(userLocation: CLLocationCoordinate2D) -> CLLocationDistance {
        return coordinate.distance(to: userLocation)
    }
}
