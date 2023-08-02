//
//  SFSymbolImage.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 01/08/2023.
//

import SwiftUI

struct SFSymbolImage: View {

    let symbolName: String
    var imageWidth: Double = 32.0
    var imageHeight: Double = 32.0

    @Binding var toggled: Bool

    var body: some View {
        Image(systemName: symbolName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                maxWidth: imageWidth,
                maxHeight: imageHeight,
                alignment: .center
            )
            .scaleEffect(toggled ? 1.0 : 0.80)
            .animation(
                .spring(duration: 0.5, bounce: 0.80)
                .repeatCount(1, autoreverses: true),
                value: toggled
            )
            .fontWeight(.regular)
            .padding(.trailing, 6)
    }
}

#Preview {
    SFSymbolImage(
        symbolName: "wrongwaysign",
        toggled: .constant(true)
    )
}
