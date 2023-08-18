//
//  XmarkButtonView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 28/07/2023.
//

import SwiftUI

struct XmarkButtonView: View {

    var foregroundColor: Color = .primary
    var backgroundColor: Color = Color(.tertiarySystemFill)

    var body: some View {
        Image(systemName: "xmark.circle.fill")
            .font(.title)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor, in: .circle)
    }
}

#Preview {
    XmarkButtonView()
        .environment(\.colorScheme, .dark)
}
