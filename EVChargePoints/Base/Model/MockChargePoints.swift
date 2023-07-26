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
            file: "SE1 7PB - London Eye - 1 mile - connector-type-id 4",
            type: ChargePointData.self
        )
        print("chargeDevices count = \(chargePointData!.chargeDevices.count)")
        return chargePointData!.chargeDevices
    }

    static var mockChargeDevice = mockChargeDevices[0]

}
