//
//  PaymentData.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct PaymentData: Identifiable, Codable {
    let id = UUID()
    var dataName: String
    var displayName: String
    var symbol: String
    var setting: Bool
}

extension PaymentData {
    enum CodingKeys: String, CodingKey {
        case dataName     = "DataName"
        case displayName  = "DisplayName"
        case symbol       = "Symbol"
        case setting      = "Setting"
    }
}

extension PaymentData {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dataName      = try container.decode(String.self, forKey: .dataName)
        displayName   = try container.decode(String.self, forKey: .displayName)
        symbol        = try container.decode(String.self, forKey: .symbol)
        setting       = try (container.decode(Int.self, forKey: .setting)) == 1 ? true : false
    }
}

extension PaymentData {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.setting, forKey: .setting)
    }
}

