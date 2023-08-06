//
//  ChargerData.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct ChargerData {

    // MARK: - Charger Speed

    enum ChargerSpeed: String, CaseIterable {
        case slow = "Slow"
        case fast = "Fast"
        case rapid = "Rapid+"
    }

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
}
