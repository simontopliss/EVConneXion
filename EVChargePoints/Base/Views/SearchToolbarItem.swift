//
//  SearchToolbarItem.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 13/08/2023.
//

import SwiftUI

struct SearchToolbarItem: View {

    @Binding var showDetails: Bool
    @Binding var showSearch: Bool

    let delay = 0.1

    var body: some View {
        Button {
            withAnimation(.snappy) {
                showDetails = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.snappy) {
                    showSearch.toggle()
                }
            }
        } label: {
            Symbols.searchSymbol
                .font(.title2)
                .foregroundStyle(Color.accentColor)
        }
    }
}

#Preview {
    SearchToolbarItem(
        showDetails: .constant(true),
        showSearch: .constant(true)
    )
}
