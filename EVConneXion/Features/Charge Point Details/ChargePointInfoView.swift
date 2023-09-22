//
//  ChargePointInfoView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 19/07/2023.
//

import SwiftUI

struct ChargePointInfoView: View {

    @EnvironmentObject private var dataManager: DataManager
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
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

#Preview {
    ChargePointInfoView(
        chargeDevice: ChargePointData.mockChargeDevice
    )
    .environmentObject(DataManager())
    .environmentObject(NavigationRouter())
}

struct LocationSection: View {

    @EnvironmentObject private var dataManager: DataManager

    let chargeDevice: ChargeDevice

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
                FormText(text: chargeDevice.chargeDeviceLocation.fullAddress)
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
                StatusView(bool: chargeDevice.onStreetFlag)
                Spacer()
            } label: {
                FormLabel(label: "ON STREET PARKING")
            }
        }
    }
}

struct PaymentSection: View {
    @EnvironmentObject private var dataManager: DataManager

    let chargeDevice: ChargeDevice

    var body: some View {
        Section("PAYMENT") {
            LabeledContent {
                VStack {
                    ForEach(chargeDevice.deviceNetworks, id: \.self) { deviceNetwork in
                        HStack {
                            FormText(text: dataManager.displayNameFor(network: deviceNetwork))
                                .fontWeight(.semibold)

                            Image(dataManager.networkGraphicFor(network: deviceNetwork))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 44, alignment: .leading)
                                .shadow(color: .secondary, radius: 3.0)
                        }

                        if deviceNetwork != chargeDevice.deviceNetworks.last {
                            Divider()
                        }
                    }
                }
            } label: {
                FormLabel(label: chargeDevice.deviceNetworks.count > 1 ? "NETWORKS" : "NETWORK")
                    .shadow(color: .secondary, radius: 1.5)
            }

            LabeledContent {
                StatusView(bool: chargeDevice.paymentRequiredFlag)
                Spacer()
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
                StatusView(bool: chargeDevice.subscriptionRequiredFlag)
                Spacer()
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

    @EnvironmentObject private var dataManager: DataManager

    let deviceAccess: DeviceAccess

    var validSection: Bool {
        return true
    }

    var body: some View {
        if validSection {
            Section("DEVICE ACCESS") {
                LabeledContent {
                   StatusView(bool: deviceAccess.open24Hours)
                    Spacer()

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
    private func regularOpeningsBuilder(regularOpenings: [RegularOpening]) -> some View {

        let openingDays = dataManager.openingsDaysFor(regularOpenings: regularOpenings)
        let openingHours = dataManager.openingsHoursFor(regularOpenings: regularOpenings)

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
