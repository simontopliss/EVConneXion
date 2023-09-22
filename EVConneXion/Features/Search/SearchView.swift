//
//  SearchView.swift
//  EVConneXion
//
//  Created by Simon Topliss on 29/06/2023.
//

import CoreLocation
import SwiftUI

struct SearchView: View {

    @Environment(\.dismiss) var dismiss

    @EnvironmentObject private var dataManager: DataManager

    /// Autocompletion for the input text
    // @ObservedObject private var autocomplete = AutocompleteObject()

    /// Input text in the text field
    @State var input: String = ""
    @State private var showInvalidPostcodeAlert = false

    @FocusState private var isFocused: Bool
    @Binding var showSheet: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            searchHeader

            if LocationManager.shared.error == nil {
                useMyLocationButton
            }

            Divider().padding(.bottom)

            if dataManager.recentSearches.isEmpty {
                contentUnavailable
            } else {
                recentSearches
            }
        }
        .padding()
        .alert("Warning", isPresented: $dataManager.hasSearchError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(dataManager.searchError?.errorDescription ?? "An error has occurred")
        }
        .alert(isPresented: $dataManager.hasNetworkError, error: dataManager.networkError) {
            // TODO: Check NetworkManager.NetworkError errorDescription
            Button("Retry") {
                searchForChargeDevices()
            }
        }
        .alert("Warning", isPresented: $showInvalidPostcodeAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Invalid postcode")
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
}

extension SearchView {

    var searchHeader: some View {
        HStack(alignment: .lastTextBaseline) {
            TextField(
                "Search",
                text: $input,
                prompt: Text("Enter postcode…")
            )
            // .onChange(of: input) {
            //     autocomplete.autocomplete(input)
            // }
            .focused($isFocused)
            .textFieldStyle(.roundedBorder)
            .foregroundStyle(AppColors.textColor)
            .onSubmit {
                searchForChargeDevices()
            }
            .submitLabel(.search)

            Button(role: .cancel) {
                showSheet.toggle()
            } label: {
                XmarkButtonView(foregroundColor: .gray)
            }
            .offset(y: 2.5)
            .padding(.bottom, 12)
        }
    }

    var useMyLocationButton: some View {
        Button {
            isFocused = false
            dismiss()
            Task {
                let userLocation = LocationManager.shared.userLocation
                await dataManager.fetchChargeDevices(
                    requestType: .latLong(userLocation.latitude, userLocation.longitude)
                )
            }
        } label: {
            Text("\(Image(systemName: "location.fill")) Use my current location")
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .padding(.bottom, 12)
    }

    var contentUnavailable: some View {
        ContentUnavailableView(
            "No recent searches",
            systemImage: Symbols.noRecentSearchesSymbolName,
            description: Text("Your search history will be displayed here.")
        )
    }
}

extension SearchView {
    func searchForChargeDevices() {
        if !dataManager.isPostcode(postcode: input) {
            showInvalidPostcodeAlert.toggle()
        } else {
            /// Get the first part of the postcode and use it to get the location
            if let outcode = input.split(separator: " ").first,
                let result = dataManager.postcodes.filter({ $0.postcode == outcode }).first {
                LocationManager.shared.userLocation(
                    coordinate: CLLocationCoordinate2D(
                        latitude: result.latitude,
                        longitude: result.longitude
                    )
                )
            }
            Task {
                dismiss()
                try await dataManager.searchForChargeDevices(searchQuery: input)
            }
        }
    }
}

extension SearchView {

    var recentSearches: some View {
        Section("Recent Searches") {
            List(dataManager.recentSearches) { recentSearch in
                Text(recentSearch.searchQuery)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
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
}
