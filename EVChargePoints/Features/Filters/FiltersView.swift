//
//  FiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct FiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var chargePointViewModel: ChargePointViewModel

    enum SelectedView: String {
        case access      = "Access"
        case connectors  = "Connectors"
        case locations   = "Locations"
        case networks    = "Networks"
        case payment     = "Payment"
        case chargers    = "Chargers"
    }

    var maximumDistanceLabel: String {
        "Maximum distance \(Int(chargePointViewModel.distance)) " +
        "\(chargePointViewModel.units == .mi ? "miles" : "kilometres")"
    }

    let verticalPadding = 10.0

    var body: some View {
        VStack {
            NavigationStack(path: $routerManager.routes) {
                List {

                    maximumDistance()

                    NavigationLink(destination: Route.filterAccessTypesView) {
                        HStack {
                            Symbols.accessSymbol
                            Text(SelectedView.access.rawValue)
                        }
                        .padding(.vertical, verticalPadding)
                    }

                    NavigationLink(destination: Route.filterChargerTypesView) {
                        HStack {
                            Symbols.chargerSymbol
                            Text(SelectedView.chargers.rawValue)
                        }
                        .padding(.vertical, verticalPadding)
                    }

                    NavigationLink(destination: Route.filterConnectorTypesView) {
                        HStack {
                            Symbols.connectorSymbol
                            Text(SelectedView.connectors.rawValue)
                        }
                        .padding(.vertical, verticalPadding)
                    }

                    NavigationLink(destination: Route.filterLocationTypesView) {
                        HStack {
                            Symbols.locationSymbol
                            Text(SelectedView.locations.rawValue)
                        }
                        .padding(.vertical, verticalPadding)
                    }

                    NavigationLink(destination: Route.filterNetworkTypesView) {
                        HStack {
                            Symbols.networkSymbol
                            Text(SelectedView.networks.rawValue)
                        }
                        .padding(.vertical, verticalPadding)
                    }

                    NavigationLink(destination: Route.filterPaymentTypesView) {
                        HStack {
                            Symbols.paymentSymbol
                            Text(SelectedView.payment.rawValue)
                        }
                        .padding(.vertical, verticalPadding)
                    }
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.textColor)
            }

//            // TODO: This should be only enabled if the user has made changes
//            Button {
//                // Apply Filters and return back to previous screen
//                routerManager.goBack()
//            } label: {
//                Text("Apply Filter")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//            }
//            .frame(width: 280, height: 44)
//            .background(Color.accentColor)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//            .padding(.bottom, 48)

        }
        .background(Color.background)
        .navigationDestination(for: Route.self) { $0 }
        .navigationTitle("Filters")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    // Go back to previous route in stack
                    routerManager.goBack()
                } label: {
                    Image(systemName: "chevron.backward")
                    Text("Back")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Save filters
                } label: {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Save Filter")
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FiltersView()
    }
    .environmentObject(FiltersViewModel())
    .environmentObject(NavigationRouter())
    .environmentObject(ChargePointViewModel())
}

extension FiltersView {

    func maximumDistance() -> some View {
        VStack(alignment: .leading) {
            Text(maximumDistanceLabel)
                .font(.body)

            Slider(
                value: $chargePointViewModel.distance,
                in: 5...100,
                step: 5
            ) {
                Text("Label")
                    .font(.subheadline)
                    .fontWeight(.regular)
            } minimumValueLabel: {
                Text("5")
                    .font(.subheadline)
                    .fontWeight(.regular)
            } maximumValueLabel: {
                Text("100")
                    .font(.subheadline)
                    .fontWeight(.regular)
            } onEditingChanged: {
                print("\($0)")
            }
        }
        .padding(.vertical, verticalPadding)
    }
}
