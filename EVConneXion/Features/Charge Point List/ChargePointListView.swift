//
//  ChargePointListView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 15/06/2023.
//

import SwiftUI

struct ChargePointListView: View {

    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var routerManager: NavigationRouter

    @State private var showSearch = false
    @State private var showDetails = false

    var body: some View {
        NavigationStack(path: $routerManager.routes) {

//            let _ = Self._printChanges()
//            let _ = print("Total: \(dataManager.filteredDevices.count)")

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
            .overlay {
                if dataManager.chargeDevices.isEmpty {
                    ContentUnavailableView(
                        "No charge devices",
                        systemImage: Symbols.noRecentSearchesSymbolName,
                        description: Text("Allow this app access to your location or enter a postcode to search.")
                    )
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
            .task {
                if dataManager.chargeDevices.isEmpty
                    && LocationManager.shared.userLocation != LocationManager.defaultLocation
                {
                    let userLocation = LocationManager.shared.userLocation
                    await dataManager.fetchChargeDevices(
                        requestType: .latLong(userLocation.latitude, userLocation.longitude)
                    )
                }
            }
        }
    }
}

#Preview {
    ChargePointListView()
        .environmentObject(DataManager())
        .environmentObject(NavigationRouter())
        .environmentObject(LocationManager.shared)
}
