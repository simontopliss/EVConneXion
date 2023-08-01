//
//  AccessFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct AccessFilter: Decodable, Identifiable, Equatable {

    let id = UUID()
    var dataName: String
    var displayName: String
    var symbol: String
    var setting: Bool

    enum CodingKeys: String, CodingKey {
        case dataName     = "DataName"
        case displayName  = "DisplayName"
        case symbol       = "Symbol"
        case setting      = "Setting"
    }

    init(from decoder: Decoder) throws {
        let container     = try decoder.container(keyedBy: CodingKeys.self)
        self.dataName     = try container.decode(String.self, forKey: .dataName)
        self.displayName  = try container.decode(String.self, forKey: .displayName)
        self.symbol       = try container.decode(String.self, forKey: .symbol)
        self.setting      = (try container.decode(Int.self, forKey: .setting)) == 1 ? true : false
    }
}
