//
//  NetworkData.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

/// ### NOTE THESE NETWORKS NEED COMBING WHEN SEARCHING AND FILTERING:
/// - BP Pulse and BP-Pulse (POLAR)
/// - Shell Recharge Solutions and Shell Recharge
/// - SSE Energy Solutions and SSE

struct NetworkData: Identifiable {
    let id = UUID()
    var network: String
    var displayName: String
    var graphicName: String
    var hex: String
    var rgb: String
    let total: Int
    var setting: Bool

    var rgbValues: RGBValue {
        RGBValue(rgb: rgb)
    }
}

extension NetworkData {
    enum CodingKeys: String, CodingKey {
        case network      = "Network"
        case displayName  = "DisplayName"
        case graphicName  = "GraphicName"
        case hex          = "Hex"
        case rgb          = "RGB"
        case total        = "Count"
        case setting      = "Setting"
    }
}

extension NetworkData: Decodable {
    init(from decoder: Decoder) throws {
        let container     = try decoder.container(keyedBy: CodingKeys.self)
        self.network      = try container.decode(String.self, forKey: .network)
        self.displayName  = try container.decode(String.self, forKey: .displayName)
        self.graphicName  = try container.decode(String.self, forKey: .graphicName)
        self.hex          = try container.decode(String.self, forKey: .hex)
        self.rgb          = try container.decode(String.self, forKey: .rgb)
        self.total        = try container.decode(Int.self, forKey: .total)
        self.setting      = (try container.decode(Int.self, forKey: .setting)) == 1 ? true : false
    }
}

extension NetworkData {
    
    struct RGBValue {
        let red: Double
        let green: Double
        let blue: Double
        
        init(rgb: String) {
            let rgbValues = rgb.components(separatedBy: ", ")
            if rgbValues.count == 3 {
                red    = Double(rgbValues[0]) ?? 0.0
                green  = Double(rgbValues[1]) ?? 0.0
                blue   = Double(rgbValues[2]) ?? 0.0
            } else {
                red    = 0.0
                blue   = 0.0
                green  = 0.0
            }
        }
    }
}
