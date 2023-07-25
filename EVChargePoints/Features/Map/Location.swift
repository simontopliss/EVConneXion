//
//  Location.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 25/07/2023.
//

import Foundation
import MapKit

struct Location {

    let chargeDeviceID: UUID

    // let latitude: String
    // let longitude: String

    // var coordinate: CLLocationCoordinate2D {
    //     guard let lat = Double(latitude), let lon = Double(longitude) else {
    //         return LocationManager.defaultLocation
    //     }
    //     return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    // }

    let coordinate: CLLocationCoordinate2D

    var mapItem: MKMapItem {
        MKMapItem(placemark: .init(coordinate: coordinate))
    }

    var distanceFromUser: CLLocationDistance // typealias of Double
}
