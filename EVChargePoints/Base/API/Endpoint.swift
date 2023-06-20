//
//  Endpoint.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/06/2023.
//

/// https://chargepoints.dft.gov.uk/api/help

import Foundation

enum Endpoint: String {
    case baseURL = "https://chargepoints.dft.gov.uk/api/retrieve"
}

extension Endpoint {

    enum DataType {
        /// registry - Charge Point Registry
        static let registry = "registry"
        /// type - Connector Types
        static let connectorType = "type"
        /// bearing - Bearings
        static let bearing = "bearing"
        /// method - Charging Methods
        static let chargingMethod = "method"
        /// mode - Charge Modes
        static let chargingMode = "mode"
        /// status - Connector Statuses
        static let connectorStatus = "status"
    }
}

extension Endpoint {

    enum RegistryDataType {

        enum Unit: String {
            case km
            case mi
        }

        enum Country: String {
            case gb
            case ie
        }

        /// connector-type-id - ID of connector
        static let connectorTypeID = "connector-type-id"
        /// country[gb|es|nl|...] - 2 character ISO 3166 country code
        static let country = "country"
        /// device-id - Unique identifier of device
        static let deviceId = "device-id"
        /// dist - Search will return all devices within distance of postcode or lat/long
        static let dist = "dist"
        /// id - ID of scheme, this will also return the scheme details
        static let id = "id"
        /// lat - Latitude (long required)
        static let lat = "lat"
        /// long - Longitude (lat required)
        static let long = "long"
        /// limit - Integer to limit results returned, don't specify to return all devices
        static let limit = "limit"
        /// postcode - Full or partial UK postcode (e.g. EC3A 7BR, EC3A 7, EC3A)
        static let postcode = "postcode"
        /// post-town - Full name of UK town or city
        static let postTown = "post-town"
        /// rated-output-kw - Rated output in kWs
        static let ratedOutputKW = "rated-output-kw"
        /// units[mi|km] - Units for dist, default is 'mi'
        static let units = "units"
    }
}

extension Endpoint {
    /// Request options
    /// format[xml|json|csv] - Output format, default is 'xml'
    enum RequestOption: String {
        case xml = "format/xml"
        case json = "format/json"
        case csv = "format/csv"
    }
}
