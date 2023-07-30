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
    var displayName: String
    var dataName: String
    var locationType: String
    var value: Bool

    enum CodingKeys: String, CodingKey {
        case displayName   = "DisplayName"
        case dataName      = "DataName"
        case locationType  = "LocationType"
        case value         = "Value"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.dataName = try container.decode(String.self, forKey: .dataName)
        self.locationType = try container.decode(String.self, forKey: .locationType)
        let value = try container.decode(Int.self, forKey: .value)
        self.value = value == 1 ? true : false
    }
}
