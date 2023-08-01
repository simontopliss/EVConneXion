//
//  SFSymbolImage.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 01/08/2023.
//

import SwiftUI

struct SFSymbolImage: View {

    let imageName: String
    var imageWidth: Double = 32.0
    var imageHeight: Double = 32.0

    @Binding var toggled: Bool

    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                maxWidth: imageWidth,
                maxHeight: imageHeight,
                alignment: .center
            )
            .scaleEffect(toggled ? 1.0 : 0.85)
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
        imageName: "wrongwaysign",
        toggled: .constant(true)
    )
}
