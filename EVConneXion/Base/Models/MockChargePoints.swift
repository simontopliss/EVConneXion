//
//  MockChargePoints.swift
//  EVConneXion
//
//  Created by Simon Topliss on 14/07/2023.
//

import Foundation

extension ChargePointData {

    static var mockChargeDevices: [ChargeDevice] {
        let chargePointData = try? StaticJSONMapper.decode(
            file: "MyLocation",
            type: ChargePointData.self
        )
        // swiftlint:disable:next force_unwrapping
        return chargePointData!.chargeDevices
    }

    static var mockChargeDevice = mockChargeDevices[0]
}
