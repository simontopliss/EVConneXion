//
//  AccessFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct LocationData: Identifiable, Codable {
    let id = UUID()
    var locationType: LocationType
    var displayName: String
    var graphicName: String
    var setting: Bool
}

extension LocationData {
    enum CodingKeys: String, CodingKey {
        case locationType = "LocationType"
        case dataName     = "DataName"
        case displayName  = "DisplayName"
        case graphicName  = "GraphicName"
        case setting      = "Setting"
    }
}

extension LocationData {
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        locationType   = try container.decode(LocationType.self, forKey: .locationType)
        displayName    = try container.decode(String.self, forKey: .displayName)
        graphicName    = try container.decode(String.self, forKey: .graphicName)
        setting        = try (container.decode(Int.self, forKey: .setting)) == 1 ? true : false
    }
}

extension LocationData {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.setting, forKey: .setting)
    }
}
