//
//  Location.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 25/07/2023.
//

import Foundation
import MapKit

struct Location {

    let id: UUID
    let chargeDeviceID: String

    let coordinate: CLLocationCoordinate2D

    var mapItem: MKMapItem {
        MKMapItem(placemark: .init(coordinate: coordinate))
    }

    var distanceFromUser: CLLocationDistance // typealias of Double
}

