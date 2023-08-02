//
//  AccessFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct LocationData: Identifiable {
    let id = UUID()
    var location: String
    var dataName: String
    var displayName: String
    var graphicName: String
    var setting: Bool
}

extension LocationData {
    enum CodingKeys: String, CodingKey {
        case location     = "Location"
        case dataName     = "DataName"
        case displayName  = "DisplayName"
        case graphicName  = "GraphicName"
        case setting      = "Setting"
    }
}

extension LocationData: Decodable {
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        location       = try container.decode(String.self, forKey: .location)
        dataName       = try container.decode(String.self, forKey: .dataName)
        displayName    = try container.decode(String.self, forKey: .displayName)
        graphicName    = try container.decode(String.self, forKey: .graphicName)
        setting        = try (container.decode(Int.self, forKey: .setting)) == 1 ? true : false
    }
}
