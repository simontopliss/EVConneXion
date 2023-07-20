//
//  RoutesView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct RoutesView: View {

    @EnvironmentObject private var vm: ChargePointViewModel
    @EnvironmentObject private var routerManager: NavigationRouter

    var body: some View {
        Text("Hello, RoutesView!")
    }
}

#Preview {
    RoutesView()
        .environmentObject(ChargePointViewModel())
        .environmentObject(NavigationRouter())
}
