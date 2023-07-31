//
//  ChargerFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

//struct ChargerFilter: Decodable, Identifiable {
//
//    let id = UUID()
//    var dataName: String
//    var displayName: String
//    let displayValues: String
//    var setting: String // Cannot be a Bool as some values are String
//
//    var displayValuesList: [String] {
//        displayValues.components(separatedBy: ", ")
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case dataName       = "DataName"
//        case displayName    = "DisplayName"
//        case displayValues  = "DisplayValues"
//        case setting        = "Setting"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container       = try decoder.container(keyedBy: CodingKeys.self)
//        self.dataName       = try container.decode(String.self, forKey: .dataName)
//        self.displayName    = try container.decode(String.self, forKey: .displayName)
//        self.displayValues  = try container.decode(String.self, forKey: .displayValues)
//        self.setting        = try container.decode(String.self, forKey: .setting)
//    }
//}

struct ChargerFilter: Identifiable {
    let id = UUID()
    // var slowCharge     = 3.0...5.0
    // var fastCharge     = 7.0...36.0
    // var rapidCharge    = 43.0...350.0
    var chargeMethods         = ["Single Phase AC", "Three Phase AC", "DC"]
    var tetheredCable         = false
    var selectedChargeMethod  = "DC"
}
