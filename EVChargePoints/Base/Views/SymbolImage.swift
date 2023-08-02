//
//  SymbolImage.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 01/08/2023.
//

import SwiftUI

struct SymbolImage: View {

    let imageName: String
    var imageWidth: Double = 32.0
    var imageHeight: Double = 32.0

    @Binding var toggled: Bool

    var body: some View {
        Image(imageName)
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
            .padding(.trailing, 6)
    }
}

#Preview {
    SymbolImage(
        imageName: "dealership-forecourt-128x128",
        toggled: .constant(true)
    )
}
