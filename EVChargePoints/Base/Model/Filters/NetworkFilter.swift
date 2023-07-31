//
//  NetworkFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct NetworkFilter: Decodable, Identifiable {

    let id = UUID()
    var networkType: String
    var dataName: String
    var displayName: String
    let total: Int // The total number of each Network to be used for sorting by most common
    var setting: Bool

    enum CodingKeys: String, CodingKey {
        case networkType  = "NetworkType"
        case dataName     = "DataName"
        case displayName  = "DisplayName"
        case setting      = "Setting"
        case total        = "Count"
    }

    init(from decoder: Decoder) throws {
        let container     = try decoder.container(keyedBy: CodingKeys.self)
        self.networkType  = try container.decode(String.self, forKey: .networkType)
        self.dataName     = try container.decode(String.self, forKey: .dataName)
        self.displayName  = try container.decode(String.self, forKey: .displayName)
        self.setting      = (try container.decode(Int.self, forKey: .setting)) == 1 ? true : false
        self.total        = try container.decode(Int.self, forKey: .total)
    }
}
