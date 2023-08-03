//
//  SFSymbolImageBounce.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 01/08/2023.
//

import SwiftUI

struct SFSymbolImageBounce: View {

    let symbolName: String
    var imageWidth: Double = 32.0
    var imageHeight: Double = 32.0

    @Binding var toggled: Bool

    var body: some View {
        Image(systemName: symbolName)
            .symbolEffect(.bounce.up, value: toggled)
            .font(.title)
            .fontWeight(.regular)
            .frame(
                maxWidth: imageWidth,
                maxHeight: imageHeight,
                alignment: .center
            )
            .padding(.trailing, 6)
    }
}

#Preview {
    SFSymbolImageBounce(
        symbolName: "wrongwaysign",
        toggled: .constant(false)
    )
}
