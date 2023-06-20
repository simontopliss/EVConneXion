//
//  ContentView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 15/06/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            await vm.fetchChargeDevices(postcode: "DE7 8LN", distance: 2)
        }
    }
}

#Preview {
    ContentView()
}
