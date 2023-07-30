//
//  NetworkFiltersView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/07/2023.
//

import SwiftUI

struct NetworkFiltersView: View {

    @EnvironmentObject private var chargePointViewModel: ChargePointViewModel
    @EnvironmentObject private var routerManager: NavigationRouter
    
    var body: some View {
        Text("NetworkTypesView")
    }
}

#Preview {
    NetworkFiltersView()
        .environmentObject(ChargePointViewModel())
        .environmentObject(NavigationRouter())
}
