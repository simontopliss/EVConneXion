//
//  ChargePointListView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 15/06/2023.
//

import SwiftUI

struct ChargePointListView: View {

    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var locationManager: LocationManager

    @State private var showSearch = false
    @State private var showDetails = false

    var body: some View {
        NavigationStack(path: $routerManager.routes) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 18) {
                    ForEach(dataManager.filteredDevices) { chargeDevice in
                        NavigationLink(value: Route.chargePointDetail(chargeDevice: chargeDevice)) {
                            ChargePointRow(chargeDevice: chargeDevice)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.background)
            .navigationTitle("Charge Devices")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Route.self) { $0 }
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    SearchToolbarItem(showDetails: $showDetails, showSearch: $showSearch)
                }
            }
            .sheet(isPresented: $showSearch, onDismiss: {
                withAnimation(.snappy) { showDetails = false }
            }, content: {
                SearchView(showSheet: $showSearch)
                    .presentationDetents([.medium])
                    .presentationBackgroundInteraction(
                        .enabled(upThrough: .medium)
                    )
                    .presentationCornerRadius(25)
                    .interactiveDismissDisabled(true)
            })
            .buttonStyle(PlainButtonStyle())
            // TODO: Go to last location, if there is one, else show London Eye with default filters
            // .task {
            //      await dataManager.fetchChargeDevices(requestType: .postcode("EC3A 7BR"))
            //      await dataManager.fetchChargeDevices(requestType: .postTown("South Shields"))
            // }
        }
    }
}

#Preview {
    ChargePointListView()
        .environmentObject(DataManager())
        .environmentObject(NavigationRouter())
        .environmentObject(LocationManager())
}
