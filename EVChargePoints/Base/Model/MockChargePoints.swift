//
//  MockChargePoints.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 14/07/2023.
//

import Foundation

extension ChargePointData {

    static var mockChargeDevices: [ChargeDevice] {
        let chargePointData = try? StaticJSONMapper.decode(
            file: "4f5a97cf06cf69028997db51d8726d28 - POD Point example",
            type: ChargePointData.self
        )
        return chargePointData!.chargeDevices
    }

    static var mockChargeDevice = mockChargeDevices[0]

}
