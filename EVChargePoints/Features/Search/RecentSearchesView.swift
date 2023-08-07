//
//  RecentSearchesView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct RecentSearchesView: View {

    @Binding var showSheet: Bool

    // TDOD: Store in UserDefautlts
    let recentSearches = ["Bingley, BD16 1BE, England", "Beverley, HU17 ORX, England", "Erewash, DE7 8LN, England"]

    var body: some View {
        VStack {
            // TODO: Show recent searches
            List { // Add selection
                Section("Recent Searches") {
                    ForEach(recentSearches, id: \.self) {
                        Text($0)
                            .foregroundStyle(AppColors.textColor)
                    }
                }
            }
            .listStyle(InsetListStyle())
        }
        .padding(.top)
        .overlay(alignment: .topTrailing) {
            Button(role: .cancel) {
                showSheet.toggle()
            } label: {
                XmarkButtonView(foregroundColor: .primary.opacity(0.2))
            }
            .padding([.top, .trailing])
        }
    }
}

#Preview {
    RecentSearchesView(showSheet: .constant(true))
        .environment(\.colorScheme, .dark)
}
