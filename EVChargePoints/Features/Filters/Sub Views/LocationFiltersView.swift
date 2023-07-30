//
//  LocationFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct LocationFiltersView: View {

    @EnvironmentObject private var chargePointViewModel: ChargePointViewModel
    @EnvironmentObject private var routerManager: NavigationRouter

    @StateObject private var vm = FiltersViewModel()
//    @State var allOn = false

    var body: some View {
        VStack {
            Form {
                Section("Locations") {
                    ForEach($vm.locationFilters) { locationFilter in
                        Setting(locationFilter: locationFilter)
                    }
                }
//                Section {
//                    Toggle(isOn: $allOn) {
//                        Text("All ") +
//                        Text(allOn ? "on" : "off")
//                    }
//                    .onSubmit {
//                        toggleAll()
//                    }
//                }
            }
        }
    }

//    func toggleAll() {
//        ForEach(0..<$vm.locationFilters.count) { index in
//            $vm.locationFilters[index].value = $allOn
//        }
//    }
}

#Preview {
    LocationFiltersView()
        .environmentObject(ChargePointViewModel())
        .environmentObject(NavigationRouter())
}

struct Setting: View {

    @Binding var locationFilter: LocationFilter

    var body: some View {
        Toggle(isOn: $locationFilter.value) {
            Text(locationFilter.displayName)
        }
//        .padding(.vertical, 4)
    }
}
