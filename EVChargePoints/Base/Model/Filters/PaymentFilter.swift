//
//  PaymentFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct PaymentFilter: Decodable, Identifiable {

    let id = UUID()
    var paymentType: String
    var dataName: String
    var displayName: String
    var setting: Bool

    enum CodingKeys: String, CodingKey {
        case paymentType  = "PaymentType"
        case dataName     = "DataName"
        case displayName  = "DisplayName"
        case setting      = "Setting"
    }

    init(from decoder: Decoder) throws {
        let container     = try decoder.container(keyedBy: CodingKeys.self)
        self.paymentType  = try container.decode(String.self, forKey: .paymentType)
        self.dataName     = try container.decode(String.self, forKey: .dataName)
        self.displayName  = try container.decode(String.self, forKey: .displayName)
        self.setting      = (try container.decode(Int.self, forKey: .setting)) == 1 ? true : false
    }
}
