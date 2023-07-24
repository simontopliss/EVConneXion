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
            file: "1b8a93def9107a6c38b35140c0a59ca0 - multiple RegularOpenings",
            type: ChargePointData.self
        )
        return chargePointData!.chargeDevices
    }

    static var mockChargeDevice = mockChargeDevices[0]

}
