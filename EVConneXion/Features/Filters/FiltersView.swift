//
//  FiltersView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct FiltersView: View {

    @EnvironmentObject private var routerManager: NavigationRouter
    @EnvironmentObject private var dataManager: DataManager

    @StateObject private var filtersViewModel = FiltersViewModel()

    // var distance: Double

    var maximumDistanceLabel: String {
        "\(Int(dataManager.userSettings.distance)) " +
            "\(dataManager.userSettings.unitSetting.rawValue)"
    }

    var body: some View {
        VStack {
            NavigationStack(path: $routerManager.routes) {
                List {
                    maximumDistance()

                    ForEach($filtersViewModel.filters) { filter in
                        FilterNavigationLink(
                            destination: filter.destination,
                            title: filter.title,
                            symbol: filter.symbol
                        )
                    }
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textColor)
            }

            Button {
                dataManager.filtersChanged = false

                if dataManager.distanceChanged {
                    Task {
                        await dataManager.fetchChargeDevices(requestType: dataManager.lastRequestType)
                    }
                } else {
                    dataManager.applyFilters()
                }
                // TODO: Apply Filters and return back to previous screen
                // let _ = print(routerManager.routes)
                // if routerManager.routes.isEmpty {
                //     routerManager.push(to: .mapView)
                // } else {
                //     routerManager.goBack()
                // }
            } label: {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                    Text("Apply Filter")
                }
                .font(.title3)
                .fontWeight(.semibold)
            }
            .frame(height: 44)
            .padding(.horizontal, 28)
            .background(dataManager.filtersChanged ? AppColors.darkBlue : Color.secondary)
            .foregroundStyle(.white)
            .cornerRadius(22)
            .padding(.bottom, 18)
            .disabled(!dataManager.filtersChanged)
        }
        .onAppear {
            // distance = dataManager.userSettings.distance
            dataManager.distanceChanged = false
            dataManager.filtersChanged = false
        }
        .alert("Warning", isPresented: $dataManager.filterResultError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(dataManager.filterResultErrorMessage)
        }
        .background(Color.background)
        .navigationDestination(for: Route.self) { $0 }
        .navigationTitle("Filters")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
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
        }
    }
}

#Preview {
    NavigationStack {
        FiltersView()
    }
    .environmentObject(DataManager())
    .environmentObject(FiltersViewModel())
    .environmentObject(NavigationRouter())
}

extension FiltersView {

    private func maximumDistance() -> some View {
        VStack(alignment: .leading) {
            Group {
                Text("Maximum distance: ")
                    .fontWeight(.regular)
                    + Text("\(maximumDistanceLabel)")
            }
            .font(.body)

            Slider(
                value: $dataManager.userSettings.distance,
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
            } onEditingChanged: { _ in
                dataManager.filtersChanged = true
            }
            .onChange(of: dataManager.userSettings.distance) { oldValue, newValue in
                dataManager.distanceChanged = oldValue != newValue
            }
        }
        .padding(.vertical, 10)
    }
}

struct FilterNavigationLink: View {

    @Binding var destination: Route
    @Binding var title: String
    @Binding var symbol: Image

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                symbol
                    .font(.title)
                    .fontWeight(.regular)
                    .foregroundStyle(.accent)
                    .frame(
                        maxWidth: Symbols.symbolWidth,
                        maxHeight: Symbols.symbolHeight,
                        alignment: .center
                    )
                    .padding(.trailing, 6)
                Text(title)
            }
            .padding(.vertical, 10)
        }
    }
}

final class FiltersViewModel: ObservableObject {

    @Published var filters: [Filter] = []

    init() {
        createFilters()
    }

    private func createFilters() {
        filters = [
            Filter(
                title: "Access",
                symbol: Symbols.accessSymbol,
                destination: Route.filterAccessTypesView
            ),
            Filter(
                title: "Charger",
                symbol: Symbols.chargerSymbol,
                destination: Route.filterChargerTypesView
            ),
            Filter(
                title: "Connector",
                symbol: Symbols.connectorSymbol,
                destination: Route.filterConnectorTypesView
            ),
            Filter(
                title: "Location",
                symbol: Symbols.locationSymbol,
                destination: Route.filterLocationTypesView
            ),
            Filter(
                title: "Network",
                symbol: Symbols.networkSymbol,
                destination: Route.filterNetworkTypesView
            ),
            Filter(
                title: "Payment",
                symbol: Symbols.paymentSymbol,
                destination: Route.filterPaymentTypesView
            )
        ]
    }
}

extension FiltersViewModel {
    struct Filter: Identifiable, Equatable {
        var id = UUID()
        var title: String
        var symbol: Image
        var destination: Route
    }
}
