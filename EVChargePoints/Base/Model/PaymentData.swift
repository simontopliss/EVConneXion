//
//  PaymentData.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct PaymentData: Identifiable {
    let id = UUID()
    var payment: String
    var dataName: String
    var displayName: String
    var symbol: String
    var setting: Bool
}

extension PaymentData {
    enum CodingKeys: String, CodingKey {
        case payment      = "Payment"
        case dataName     = "DataName"
        case displayName  = "DisplayName"
        case symbol       = "Symbol"
        case setting      = "Setting"
    }
}

extension PaymentData: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        payment       = try container.decode(String.self, forKey: .payment)
        dataName      = try container.decode(String.self, forKey: .dataName)
        displayName   = try container.decode(String.self, forKey: .displayName)
        symbol        = try container.decode(String.self, forKey: .symbol)
        setting       = try (container.decode(Int.self, forKey: .setting)) == 1 ? true : false
    }
}
