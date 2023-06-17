//
//  Endpoint.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/06/2023.
//

/// https://chargepoints.dft.gov.uk/api/help

import Foundation

enum Endpoint: String {
    case baseURL = "http://chargepoints.dft.gov.uk/api/retrieve/"
}

extension Endpoint {
    /// Data types
    enum DataType: String {
        /// registry - Charge Point Registry
        case registry
        /// type - Connector Types
        case type
        /// bearing - Bearings
        case bearing
        /// method - Charging Methods
        case method
        /// mode - Charge Modes
        case mode
        /// status - Connector Statuses
        case status
    }
}

extension Endpoint {
    /// Request options
    /// format[xml|json|csv] - Output format, default is 'xml'
    enum RequestOptions: String {
        case xml
        case json
        case csv
    }
}

extension Endpoint {
    /// Registry data type
    enum RegistryDataType: String {
        /// connector-type-id - ID of connector
        case connectorTypeID = "connector-type-id"
        /// country[gb|es|nl|...] - 2 character ISO 3166 country code
        case country
        /// device-id - Unique identifier of device
        case deviceId = "device-id"
        /// dist - Search will return all devices within distance of postcode or lat/long
        case dist
        /// id - ID of scheme, this will also return the scheme details
        case id
        /// lat - Latitude (long required)
        case lat
        /// long - Longitude (lat required)
        case long
        /// limit - Integer to limit results returned, don't specify to return all devices
        case limit
        /// postcode - Full or partial UK postcode (e.g. EC3A 7BR, EC3A 7, EC3A)
        case postcode
        /// post-town - Full name of UK town or city
        case postTown = "post-town"
        /// rated-output-kw - Rated output in kWs
        case ratedOutputKW = "rated-output-kw"
        /// units[mi|km] - Units for dist, default is 'mi'
        case units
    }
}
