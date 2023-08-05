//
//  ChargerData.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct ChargerData {
    var chargeSpeeds    = ["Slow", "Fast", "Rapid+"]
    var chargeMethods   = ["Single Phase AC", "Three Phase AC", "DC"]
    var tetheredCable   = false

    var selectedSpeed   = "Fast"
    var selectedMethod  = "DC"

    var chargeSpeedsSymbol: String {
        if selectedSpeed == "Slow" {
            return "gauge.with.dots.needle.bottom.0percent"
        } else if selectedSpeed == "Fast" {
            return "gauge.with.dots.needle.bottom.50percent"
        } else {
            return "gauge.with.dots.needle.bottom.100percent"
        }
    }

    var chargeMethodsSymbol = "ev.charger"

    var tetheredCableSymbol: String {
        tetheredCable ? "powercord.fill" : "powercord"
    }
}
