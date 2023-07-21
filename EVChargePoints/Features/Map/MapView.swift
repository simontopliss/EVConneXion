//
//  MapView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import MapKit
import Observation
import SwiftUI

struct MapView: View {

    @Environment(ChargePointViewModel.self) private var vm
    @Environment(NavigationRouter.self) private var routerManager

    var body: some View {
        Text("Hello, MapView!")
    }
}

#Preview {
    MapView()
        .environment(ChargePointViewModel())
        .environment(NavigationRouter())
}
