//
//  ChargerData.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct ChargerData: Codable {

    // MARK: - Charger Speed

    var chargeSpeeds = ["Slow", "Fast", "Rapid+"]
    var chargeSpeedsSymbol: String {
        if selectedSpeed == "Slow" {
            return "gauge.with.dots.needle.bottom.0percent"
        } else if selectedSpeed == "Fast" {
            return "gauge.with.dots.needle.bottom.50percent"
        } else {
            return "gauge.with.dots.needle.bottom.100percent"
        }
    }
    var selectedSpeed = "Fast"

    // MARK: - Charge Method

    var chargeMethods: [ChargeMethod] = [.dc, .singlePhaseAc, .threePhaseAc]
    var chargeMethodsSymbol = "ev.charger"
    var selectedMethod = ChargeMethod.dc

    // MARK: - Charger Tethered Cable

    var tetheredCable = false
    var tetheredCableSymbol: String {
        tetheredCable ? "powercord.fill" : "powercord"
    }

    enum CodingKeys: String, CodingKey {
        case selectedSpeed = "SelectedSpeed"
        case selectedMethod = "SelectedMethod"
        case tetheredCable = "TetheredCable"
    }
}

extension ChargerData {
    enum ChargerSpeed: String, CaseIterable {
        case slow = "Slow"
        case fast = "Fast"
        case rapid = "Rapid+"
    }
}

extension ChargerData {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.selectedSpeed = try container.decode(String.self, forKey: .selectedSpeed)
        self.selectedMethod = try container.decode(ChargeMethod.self, forKey: .selectedMethod)
        self.tetheredCable = try container.decode(Bool.self, forKey: .tetheredCable)
    }
}

extension ChargerData {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.selectedSpeed, forKey: .selectedSpeed)
        try container.encode(self.selectedMethod, forKey: .selectedMethod)
        try container.encode(self.tetheredCable, forKey: .tetheredCable)
    }
}

extension ChargerData {
    static func saveData(data: ChargerData) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            encoder.outputFormatting = .prettyPrinted

            let data = try? encoder.encode(data)

            let savePath = FileManager.documentsDirectory
                .appendingPathComponent(EVChargePointsApp.JSONFiles.charger.rawValue)
                .appendingPathExtension("json")

            try data?.write(to: savePath, options: [.atomic, .completeFileProtection])

        } catch {
            print(error)
        }
    }
}
