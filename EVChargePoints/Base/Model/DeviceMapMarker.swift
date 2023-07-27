//
//  DeviceMapMarker.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 27/07/2023.
//

import MapKit
import SwiftUI

struct DeviceMapMarker {

    var coordinate: CLLocationCoordinate2D
    var mapItem: MKMapItem
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
        distanceFromUser = coordinate.distance(to: LocationManager.defaultLocation)
    }
}
