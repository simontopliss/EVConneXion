//
//  RecentSearchesView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct RecentSearchesView: View {

    @EnvironmentObject private var dataManager: DataManager

    @Binding var showSheet: Bool

    let recentSearches = ["Bingley, BD16 1BE, England", "Beverley, HU17 ORX, England", "Erewash, DE7 8LN, England"]

    var body: some View {
        VStack {
            if dataManager.userSettings.recentSearches.isEmpty {
                ContentUnavailableView(
                    "No App Ideas",
                    systemImage: "square.stack.3d.up.slash",
                    description: Text("Tap add to create your first app idea.")
                )
            } else {
                // TODO: Show recent searches
                List { // Add selection
                    Section("Recent Searches") {
                        ForEach(dataManager.userSettings.recentSearches, id: \.self) {
                            Text($0)
                                .foregroundStyle(AppColors.textColor)
                        }
                    }
                }
                .listStyle(InsetListStyle())
            }
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
        .environmentObject(DataManager())
        //.environment(\.colorScheme, .dark)
}
