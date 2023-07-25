//
//  ChargeDeviceLocation.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation
import MapKit

// MARK: - ChargeDeviceLocation

struct ChargeDeviceLocation: Decodable {

    var latitude: String
    var longitude: String
    var address: [String: String?]
    var locationShortDescription: String?
    var locationLongDescription: String?

    let coordinate: CLLocationCoordinate2D = LocationManager.defaultLocation

    var mapItem: MKMapItem {
        MKMapItem(placemark: .init(coordinate: coordinate))
    }

    var distanceFromUser: CLLocationDistance = 0.0 // typealias of Double

    enum CodingKeys: String, CodingKey {
        case latitude                  = "Latitude"
        case longitude                 = "Longitude"
        case address                   = "Address"
        case locationShortDescription  = "LocationShortDescription"
        case locationLongDescription   = "LocationLongDescription"
    }

}
