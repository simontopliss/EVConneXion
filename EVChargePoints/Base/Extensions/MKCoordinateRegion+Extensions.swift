//
//  MKCoordinateRegion+Extensions.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 23/07/2023.
//

import Foundation
import MapKit

extension MKCoordinateRegion {

    static func defaultRegion() -> MKCoordinateRegion {
        // London Eye
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.503351, longitude: -0.119623),
            span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        )
    }

//    static func regionFromLandmark(_ landmark: Landmark) -> MKCoordinateRegion {
//        MKCoordinateRegion(
//            center: landmark.coordinate,
//            span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
//        )
//    }

}
