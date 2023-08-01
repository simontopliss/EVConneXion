//
//  AccessFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

// MARK: - LocationFilter

struct LocationFilter: Decodable, Identifiable {

    let id = UUID()
    var locationType: String
    var dataName: String
    var displayName: String
    var symbol: String
    var setting: Bool

    enum CodingKeys: String, CodingKey {
        case locationType  = "LocationType"
        case dataName      = "DataName"
        case displayName   = "DisplayName"
        case symbol        = "Symbol"
        case setting       = "Setting"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        locationType  = try container.decode(String.self, forKey: .locationType)
        dataName      = try container.decode(String.self, forKey: .dataName)
        displayName   = try container.decode(String.self, forKey: .displayName)
        symbol        = try container.decode(String.self, forKey: .symbol)
        setting       = try (container.decode(Int.self, forKey: .setting)) == 1 ? true : false
    }
}
