//
//  NetworkGraphic.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

struct NetworkGraphic: Decodable {
    let network: String
    let filename: String
    let displayName: String
    let hex: String
    let rgb: String

    var rgbValues: RGBValue {
        RGBValue(rgb: rgb)
    }

    enum CodingKeys: String, CodingKey {
        case network      = "Network"
        case filename     = "Filename"
        case displayName  = "DisplayName"
        case hex          = "Hex"
        case rgb          = "RGB"
    }
}

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
