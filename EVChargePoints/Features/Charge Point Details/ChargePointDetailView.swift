//
//  ChargePointDetailView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct ChargePointDetailView: View {

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
        .navigationTitle(chargeDevice.chargeDeviceName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChargePointDetailView(
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
        Validator.isValid(chargeDevice.parkingFeesDetails) || Validator.isValid(chargeDevice.accessRestrictionDetails) || Validator.isValid(chargeDevice.physicalRestrictionText) ? true : false
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

    var body: some View {
        Section("PAYMENT") {
            LabeledContent {
                HStack {
                    Image(vm.getNetworkGraphicForAttribution(attribution: chargeDevice.attribution))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 44, alignment: .leading)
                    FormText(text: vm.getNetworkDisplayName(attribution: chargeDevice.attribution))
                        .fontWeight(.semibold)
                }
            } label: {
                FormLabel(label: "NETWORK")
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

struct FormText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            .foregroundColor(Colors.textColor)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FormLabel: View {
    let label: String

    var body: some View {
        Text(label)
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            .frame(width: 80, alignment: .leading)
            .foregroundColor(.secondary)
    }
}

