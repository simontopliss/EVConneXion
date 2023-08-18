//
//  SearchView.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 29/06/2023.
//

import SwiftUI

struct SearchView: View {

    @EnvironmentObject private var dataManager: DataManager
    @Environment(\.dismiss) var dismiss

    /// Autocompletion for the input text
    @ObservedObject private var autocomplete = AutocompleteObject()

    /// Input text in the text field
    @State var input: String = ""

    @FocusState private var isFocused: Bool
    @Binding var showSheet: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            searchHeader

            Divider()
                .padding(.bottom)

            if dataManager.recentSearches.isEmpty {
                contentUnavailable
            } else {
                Section("Recent Searches") {
                    List(dataManager.recentSearches) { recentSearch in
                        Text(recentSearch.searchQuery)
                            .foregroundStyle(AppColors.textColor)
                            .tag(recentSearch.id)
                            .onTapGesture {
                                input = recentSearch.searchQuery
                                searchForChargeDevices()
                            }
                    }
                }
                .listStyle(.inset)
            }

            if !autocomplete.suggestions.isEmpty {
                Section("Suggestions") {
                    List(autocomplete.suggestions, id: \.self) { suggestion in
                        Text(suggestion)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .onTapGesture {
                                input = suggestion
                            }
                    }
                    .listStyle(.inset)
                }
            }
        }
        .padding()
        .alert("Warning", isPresented: $dataManager.searchError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(dataManager.searchErrorMessage)
        }
        .alert(isPresented: $dataManager.hasError, error: dataManager.networkError) {
            // TODO: Check NetworkManager.NetworkError errorDescription
            Button("Retry") {
                searchForChargeDevices()
            }
        }
        .padding(.top)
        .onAppear {
            isFocused = true
        }
    }
}

#Preview {
    SearchView(showSheet: .constant(true))
        .environmentObject(DataManager())
    // .environment(\.colorScheme, .dark)
}

extension SearchView {

    var searchHeader: some View {
        HStack(alignment: .lastTextBaseline) {
            TextField(
                "Search",
                text: $input,
                prompt: Text("Enter postcode, town or city…")
            )
            .onChange(of: input) { _, _ in
                autocomplete.autocomplete(input)
            }
            .focused($isFocused)
            .textFieldStyle(.roundedBorder)
            .foregroundStyle(AppColors.textColor)
            .onSubmit {
                searchForChargeDevices()
                // TODO: Navigate to MapView or ListView if successful and zoom map to region from searchQuery
            }
            .submitLabel(.search)

            Button(role: .cancel) {
                showSheet.toggle()
            } label: {
                XmarkButtonView(foregroundColor: .gray)
            }
            .offset(y: 2.5)
            .padding(.bottom)
        }
    }

    var contentUnavailable: some View {
        ContentUnavailableView(
            "No recent searches",
            systemImage: Symbols.noRecentSearchesSymbolName,
            description: Text("Your search history will be displayed here.")
        )
        // .foregroundStyle(AppColors.textColor)
    }
}

extension SearchView {
    func searchForChargeDevices() {
        Task {
            await dataManager.searchForChargeDevices(searchQuery: input)
            dismiss()
        }
    }
}
