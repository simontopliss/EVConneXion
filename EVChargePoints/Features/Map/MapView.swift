//
//  MapView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import MapKit
import SwiftUI

struct MapView: View {

    @EnvironmentObject private var vm: ChargePointViewModel
    @EnvironmentObject private var routerManager: NavigationRouter

    var body: some View {
        Text("Hello, MapView!")
    }
}

#Preview {
    MapView()
        .environmentObject(ChargePointViewModel())
        .environmentObject(NavigationRouter())
}
