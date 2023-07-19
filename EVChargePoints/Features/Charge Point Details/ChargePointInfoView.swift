//
//  ChargePointInfoView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 19/07/2023.
//

import SwiftUI

struct ChargePointInfoView: View {

    let vm: ChargePointViewModel
    let chargeDevice: ChargeDevice
    var address: Address {
        vm.createAddress(chargeDevice: chargeDevice)
    }

    var body: some View {
        Form {
            LocationSection(chargeDevice: chargeDevice, address: address)
            ParkingSection(chargeDevice: chargeDevice)
            PaymentSection(chargeDevice: chargeDevice, vm: vm)
        }
    }
}

#Preview {
    ChargePointInfoView(
        vm: ChargePointViewModel(),
        chargeDevice: ChargePointData.mockChargeDevice
    )
    .environmentObject(ChargePointViewModel())
}

struct LocationSection: View {
    let chargeDevice: ChargeDevice
    let address: Address

    var body: some View {
        Section("LOCATION") {
            LabeledContent {
                FormText(text: chargeDevice.locationType.rawValue)
                    .fontWeight(.semibold)
           } label: {
                FormLabel(label: "TYPE")
            }

            LabeledContent {
                FormText(text: address.fullAddress)
            } label: {
                FormLabel(label: "ADDRESS")
            }
        }
    }
}

struct ParkingSection: View {
    let chargeDevice: ChargeDevice

    var validSection: Bool {
        Validator.isValid(chargeDevice.parkingFeesDetails) ||
        Validator.isValid(chargeDevice.accessRestrictionDetails) ||
        Validator.isValid(chargeDevice.physicalRestrictionText) ? true : false
    }

    var body: some View {
        if validSection {
            Section("PARKING") {
                if Validator.isValid(chargeDevice.parkingFeesDetails) {
                    LabeledContent {
                        FormText(text: chargeDevice.parkingFeesDetails!)
                    } label: {
                        FormLabel(label: "DETAILS")
                    }
                }

                if Validator.isValid(chargeDevice.accessRestrictionDetails) {
                    LabeledContent {
                        FormText(text: chargeDevice.accessRestrictionDetails!)
                    } label: {
                        FormLabel(label: "ACCESS")
                    }
                }

                if Validator.isValid(chargeDevice.physicalRestrictionText) {
                    LabeledContent {
                        FormText(text: chargeDevice.physicalRestrictionText!)
                    } label: {
                        FormLabel(label: "RESTRICTIONS")
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct PaymentSection: View {
    let chargeDevice: ChargeDevice
    let vm: ChargePointViewModel
    var deviceNetworks: [String] {
        vm.separate(deviceNetworks: chargeDevice.deviceNetworks)
    }

    var body: some View {
        Section("PAYMENT") {
            LabeledContent {
                VStack {
                    ForEach(0..<deviceNetworks.count, id: \.self) { networkCount in
                        HStack {
                            FormText(text: vm.displayNameFor(network: deviceNetworks[networkCount]))
                                .fontWeight(.semibold)

                            Image(vm.networkGraphicFor(network: deviceNetworks[networkCount]))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 44, alignment: .leading)
                        }

                        if networkCount < deviceNetworks.count - 1 {
                            Divider()
                        }
                    }
                }
            } label: {
                FormLabel(label: deviceNetworks.count > 1 ? "NETWORKS" : "NETWORK")
            }

            LabeledContent {
                FormText(text: chargeDevice.paymentRequiredFlag ? Symbols.no : Symbols.yes)
            } label: {
                FormLabel(label: "FREE TO USE")
            }

            if Validator.isValid(chargeDevice.paymentDetails) {
                LabeledContent {
                    FormText(text: chargeDevice.paymentDetails!)
                } label: {
                    FormLabel(label: "DETAILS")
                }
            }
        }
    }
}
