//
//  VM+AddressFormatting.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 27/07/2023.
//

import Foundation

// MARK: - Address Formatting

extension ChargePointViewModel {

    /// Creates a String for the address
    /// - Parameter chargeDevice: ChargeDevice
    /// - Returns: String of the address given
    func createAddress(chargeDevice: ChargeDevice) -> Address {
        return Address(chargeDeviceLocation: chargeDevice.chargeDeviceLocation)
    }
}
