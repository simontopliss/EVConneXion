//
//  ChargePointInfoView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 19/07/2023.
//

import SwiftUI

struct ChargePointInfoView: View {

    @EnvironmentObject private var vm: ChargePointViewModel
    @EnvironmentObject private var routerManager: NavigationRouter

    let chargeDevice: ChargeDevice

    var body: some View {
        Form {
            LocationSection(chargeDevice: chargeDevice)
            ParkingSection(chargeDevice: chargeDevice)
            PaymentSection(chargeDevice: chargeDevice)
            if let deviceAccess = chargeDevice.deviceAccess {
                DeviceAccessSection(deviceAccess: deviceAccess)
            }
        }
    }
}

#Preview {
    ChargePointInfoView(
        chargeDevice: ChargePointData.mockChargeDevice
    )
    .environmentObject(ChargePointViewModel())
    .environmentObject(NavigationRouter())
}

struct LocationSection: View {

    @EnvironmentObject private var vm: ChargePointViewModel

    let chargeDevice: ChargeDevice
    var address: Address {
        vm.createAddress(chargeDevice: chargeDevice)
    }

    var description: String {
        if Validator.isValid(chargeDevice.chargeDeviceLocation.locationShortDescription) &&
            Validator.isValid(chargeDevice.chargeDeviceLocation.locationLongDescription)
        {
            return chargeDevice.chargeDeviceLocation.locationLongDescription!
        } else if Validator.isValid(chargeDevice.chargeDeviceLocation.locationShortDescription) {
            return chargeDevice.chargeDeviceLocation.locationShortDescription!
        } else if Validator.isValid(chargeDevice.chargeDeviceLocation.locationLongDescription) {
            return chargeDevice.chargeDeviceLocation.locationLongDescription!
        } else {
            return ""
        }
    }

    var body: some View {
        Section("LOCATION") {
            LabeledContent {
                FormText(text: chargeDevice.locationType.rawValue)
                    .fontWeight(.semibold)
            } label: {
                FormLabel(label: "TYPE")
            }

            if !description.isEmpty {
                LabeledContent {
                    FormText(text: description)
                } label: {
                    FormLabel(label: "MORE INFO")
                }
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

    var body: some View {
        Section("PARKING") {
            if Validator.isValid(chargeDevice.parkingFeesDetails, forType: .parking) {
                LabeledContent {
                    FormText(text: chargeDevice.parkingFeesDetails!)
                } label: {
                    FormLabel(label: "DETAILS")
                }
            }

            if Validator.isValid(chargeDevice.accessRestrictionDetails, forType: .parking) {
                LabeledContent {
                    FormText(text: chargeDevice.accessRestrictionDetails!)
                } label: {
                    FormLabel(label: "ACCESS")
                }
            }

            if Validator.isValid(chargeDevice.physicalRestrictionText, forType: .parking) {
                LabeledContent {
                    FormText(text: chargeDevice.physicalRestrictionText!)
                } label: {
                    FormLabel(label: "RESTRICTIONS")
                }
            }

            LabeledContent {
                FormText(text: chargeDevice.onStreetFlag ? Symbols.yes : Symbols.no)
            } label: {
                FormLabel(label: "ON STREET PARKING")
            }
        }
    }
}

struct PaymentSection: View {
    @EnvironmentObject private var vm: ChargePointViewModel

    let chargeDevice: ChargeDevice
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

            if Validator.isValid(chargeDevice.paymentDetails, forType: .details) {
                LabeledContent {
                    FormText(text: chargeDevice.paymentDetails!)
                } label: {
                    FormLabel(label: "DETAILS")
                }
            }

            LabeledContent {
                FormText(text: chargeDevice.subscriptionRequiredFlag ? Symbols.yes : Symbols.no)
            } label: {
                FormLabel(label: "SUBS. REQUIRED")
            }

            if Validator.isValid(chargeDevice.subscriptionDetails, forType: .details) {
                LabeledContent {
                    FormText(text: chargeDevice.subscriptionDetails!)
                } label: {
                    FormLabel(label: "SUBS. DETAILS")
                }
            }
        }
    }
}

struct DeviceAccessSection: View {

    @EnvironmentObject private var vm: ChargePointViewModel

    let deviceAccess: DeviceAccess

    var validSection: Bool {
        return true
    }

    var body: some View {
        if validSection {
            Section("DEVICE ACCESS") {
                LabeledContent {
                    FormText(text: deviceAccess.open24Hours ? Symbols.yes : Symbols.no)
                } label: {
                    FormLabel(label: "OPEN 24 HOURS")
                }

                if let regularOpenings = deviceAccess.regularOpenings {
                    regularOpeningsBuilder(regularOpenings: regularOpenings)
                }

                // TODO: Investigate deviceAccess.annualOpening options
            }
        } else {
            EmptyView()
        }
    }
}

extension DeviceAccessSection {

    @ViewBuilder
    func regularOpeningsBuilder(regularOpenings: [RegularOpening]) -> some View {

        let openingDays = vm.openingsDaysFor(regularOpenings: regularOpenings)
        let openingHours = vm.openingsHoursFor(regularOpenings: regularOpenings)

        HStack {
            Text("REGULAR OPENINGS")
                .font(.subheadline.leading(.tight))
                .multilineTextAlignment(.leading)
                .frame(width: 90, alignment: .leading)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading) {
                if openingDays.count == openingHours.count {
                    ForEach(0..<openingDays.count, id: \.self) { index in
                        HStack {
                            Text(openingDays[index])
                                .frame(width: 85, alignment: .leading)
                            Text(openingHours[index])
                                .frame(alignment: .trailing)
                        }
                    }

                } else if openingDays.isEmpty && !openingHours.isEmpty {
                    ForEach(0..<openingHours.count, id: \.self) { index in
                        Text(openingHours[index])
                    }

                } else {
                    #if DEBUG
                    let _ = print("DEBUG: 💀🐞")
                    let _ = dump(openingDays)
                    let _ = dump(openingHours)
                    fatalError("I missed a condition here")
                    #endif
                }
            }
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(AppColors.textColor)
        }
    }
}
