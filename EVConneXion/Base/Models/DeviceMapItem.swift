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
    var distanceFromUser: CLLocationDistance // typealias of Double

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
        // TODO: Need to pass the user's current location somehow
        distanceFromUser = coordinate.distance(to: LocationManager.defaultLocation)
    }
}
