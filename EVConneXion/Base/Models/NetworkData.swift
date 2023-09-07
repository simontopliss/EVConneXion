//
//  NetworkData.swift
//  EVConneXion
//
//  Created by Simon Topliss on 17/07/2023.
//

import Foundation

/// ### NOTE THESE NETWORKS NEED COMBING WHEN SEARCHING AND FILTERING:
/// - BP Pulse and BP-Pulse (POLAR)
/// - Shell Recharge Solutions and Shell Recharge
/// - SSE Energy Solutions and SSE

struct NetworkData: Identifiable, Codable {
    let id: UUID
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
        case id           = "ID"
        case network      = "Network"
        case displayName  = "DisplayName"
        case graphicName  = "GraphicName"
        case hex          = "Hex"
        case rgb          = "RGB"
        case total        = "Count"
        case setting      = "Setting"
    }
}

extension NetworkData {
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        id             = try container.decode(UUID.self, forKey: .id)
        network        = try container.decode(String.self, forKey: .network)
        displayName    = try container.decode(String.self, forKey: .displayName)
        graphicName    = try container.decode(String.self, forKey: .graphicName)
        hex            = try container.decode(String.self, forKey: .hex)
        rgb            = try container.decode(String.self, forKey: .rgb)
        total          = try container.decode(Int.self, forKey: .total)
        do {
            setting    = try (container.decode(Int.self, forKey: .setting)) == 1 ? true : false
        } catch {
            setting    = try container.decode(Bool.self, forKey: .setting)
        }
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

extension NetworkData {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(network, forKey: .network)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(graphicName, forKey: .graphicName)
        try container.encode(hex, forKey: .hex)
        try container.encode(rgb, forKey: .rgb)
        try container.encode(total, forKey: .total)
        try container.encode(setting, forKey: .setting)
    }
}

extension NetworkData {
    static func saveData(data: [NetworkData]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            encoder.outputFormatting = .prettyPrinted

            let data = try? encoder.encode(data)

            let savePath = FileManager.documentsDirectory
                .appendingPathComponent("NetworkData")
                .appendingPathExtension("json")

            try data?.write(to: savePath, options: [.atomic, .completeFileProtection])

        } catch {
            print(error)
        }
    }
}
