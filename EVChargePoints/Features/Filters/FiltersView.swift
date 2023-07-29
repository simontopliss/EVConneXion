//
//  FiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct FiltersView: View {

    @EnvironmentObject private var chargePointViewModel: ChargePointViewModel
    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var locationManager: LocationManager

    enum SelectedView: String {
        case access = "Access"
        case connectors = "Connectors"
        case locations = "Locations"
        case networks = "Networks"
        case payment = "Payment"
        case chargers = "Chargers"
    }

    var body: some View {
        VStack {
            NavigationStack(path: $routerManager.routes) {
                List {
                    NavigationLink(destination: Route.filterAccessTypesView) {
                        HStack {
                            Image(systemName: "parkingsign.circle")
                            Text(SelectedView.access.rawValue)
                        }
                        .padding(.vertical, 12)
                    }
                    NavigationLink(destination: Route.filterConnectorTypesView) {
                        HStack {
                            Image(systemName: "ev.plug.ac.type.2")
                            Text(SelectedView.connectors.rawValue)
                        }
                        .padding(.vertical, 12)
                    }
                    NavigationLink(destination: Route.filterLocationTypesView) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse.circle")
                            Text(SelectedView.locations.rawValue)
                        }
                        .padding(.vertical, 12)
                    }
                    NavigationLink(destination: Route.filterNetworkTypesView) {
                        HStack {
                            Image(systemName: "network")
                            Text(SelectedView.networks.rawValue)
                        }
                        .padding(.vertical, 12)
                    }
                    NavigationLink(destination: Route.filterPaymentTypesView) {
                        HStack {
                            PaymentSymbolView()
                            Text(SelectedView.payment.rawValue)
                        }
                        .padding(.vertical, 12)
                    }
                    NavigationLink(destination: Route.filterChargerTypesView) {
                        HStack {
                            Image(systemName: "bolt.circle")
                            Text(SelectedView.chargers.rawValue)
                        }
                        .padding(.vertical, 12)
                    }
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.textColor)
            }

            // TODO: This should be only enabled if the user has made changes
            Button {
                // Apply Filters and return back to previous screen
                routerManager.goBack()
            } label: {
                Text("Apply Filter")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .frame(width: 280, height: 44)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.bottom, 48)
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
    .environmentObject(ChargePointViewModel())
    .environmentObject(NavigationRouter())
    .environmentObject(LocationManager())
}
