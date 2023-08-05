//
//  AccessData.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct AccessData: Identifiable {
    let id = UUID()
    var access: String
    var dataName: String
    var displayName: String
    var symbol: String
    var setting: Bool
}

extension AccessData {
    enum CodingKeys: String, CodingKey {
        case access       = "Access"
        case dataName     = "DataName"
        case displayName  = "DisplayName"
        case symbol       = "Symbol"
        case setting      = "Setting"
    }
}

extension AccessData: Decodable {
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        access         = try container.decode(String.self, forKey: .access)
        dataName       = try container.decode(String.self, forKey: .dataName)
        displayName    = try container.decode(String.self, forKey: .displayName)
        symbol         = try container.decode(String.self, forKey: .symbol)
        setting        = try (container.decode(Int.self, forKey: .setting)) == 1 ? true : false
    }
}
