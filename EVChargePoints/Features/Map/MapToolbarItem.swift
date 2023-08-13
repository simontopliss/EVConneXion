//
//  MapToolbarItem.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 13/08/2023.
//

import SwiftUI

struct MapToolbarItem: View {

    @Binding var showDetails: Bool
    @Binding var showSearch: Bool

    var body: some View {
        Button {
            withAnimation(.snappy) {
                showDetails = false
            }
            // NOTE: These seem to cause the "The compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions" bug
            // DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            // try await Task.sleep(nanoseconds: delay) { // Swift 5.5 version
            withAnimation(.snappy) {
                showSearch.toggle()
            }
            // }
        } label: {
            Symbols.searchSymbol
                .font(.title2)
                .foregroundStyle(Color.accentColor)
        }
    }
}

#Preview {
    MapToolbarItem(
        showDetails: .constant(true),
        showSearch: .constant(true)
    )
}
