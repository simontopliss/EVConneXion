//
//  UserAnnotationView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 13/08/2023.
//

import MapKit
import SwiftUI

struct UserAnnotationView: View {

    @Environment(\.colorScheme) var colorScheme

    @State private var userLocationScale: CGFloat = 0.6
    let duration = 0.8
    let delay: Double = 0.1
    let pinScale: CGFloat = 0.75

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundStyle(colorScheme == .dark ? .pink.opacity(0.50) : .pink.opacity(0.25))

            Circle()
                .frame(width: 20, height: 20)
                .foregroundStyle(.white)

            Circle()
                .frame(width: 12, height: 12)
                .foregroundStyle(.pink)
        }
        .scaleEffect(userLocationScale)
        .animation(
            Animation.easeInOut(duration: duration)
                .repeatForever()
                .delay(delay),
            value: userLocationScale
        )
        .onAppear {
            withAnimation {
                userLocationScale = 1
            }
        }
    }
}

#Preview {
    UserAnnotationView()
}
