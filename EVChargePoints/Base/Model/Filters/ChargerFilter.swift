//
//  ChargerFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct ChargerFilter {
//    var slowCharge     = 3...5
//    var fastCharge     = 7...36
//    var rapidCharge    = 43...350
    var chargeSpeeds    = ["Slow", "Fast", "Rapid+"]
    var chargeMethods   = ["Single Phase AC", "Three Phase AC", "DC"]
    var tetheredCable   = false

    var selectedSpeed   = "Fast"
    var selectedMethod  = "DC"
}
