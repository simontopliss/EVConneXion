//
//  RoutesView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import Observation
import SwiftUI

struct RoutesView: View {

    @Environment(ChargePointViewModel.self) private var vm
    @Environment(NavigationRouter.self) private var routerManager

    var body: some View {
        Text("Hello, RoutesView!")
    }
}

#Preview {
    RoutesView()
        .environment(ChargePointViewModel())
        .environment(NavigationRouter())
}
