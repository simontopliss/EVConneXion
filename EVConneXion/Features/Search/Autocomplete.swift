//
//  Autocomplete.swift
//  Autocomplete
//
//  Created by Dmytro Anokhin on 21/09/2021.
//

import Combine
import Foundation

@MainActor
final class AutocompleteObject: ObservableObject {

    let delay: TimeInterval = 0.25
    private var postcodes: [Postcode] = []
    private var addresses: [String] = []

    @Published var suggestions: [String] = []

    init() {
        postcodes = loadPostcodes()
        addresses = createTownCountyString()
    }

    private var task: Task<Void, Never>?

    func autocomplete(_ text: String) {
        guard !text.isEmpty else {
            suggestions = []
            task?.cancel()
            return
        }

        task?.cancel()

        task = Task {
            do {
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000.0))

                guard !Task.isCancelled else {
                    return
                }

                // let newSuggestions = await citiesCache.lookup(prefix: text)
                let newSuggestions = lookup(prefix: text)

                if isSingleSuggestion(suggestions, equalTo: text) {
                    // Do not offer only one suggestion same as the input
                    suggestions = []
                } else {
                    suggestions = newSuggestions
                }
            } catch {
                print(error)
            }
        }
    }

    private func isSingleSuggestion(_ suggestions: [String], equalTo text: String) -> Bool {
        guard let suggestion = suggestions.first, suggestions.count == 1 else {
            return false
        }

        return suggestion.lowercased() == text.lowercased()
    }

    private func loadPostcodes() -> [Postcode] {
        // swiftlint:disable:next force_try
        return try! StaticJSONMapper.decode(
            file: "uk-postcodes",
            type: [Postcode].self,
            location: .bundle
        )
    }

    /// Build an array of town, county
    private func createTownCountyString() -> [String] {
        var addresses: [String] = []
        for item in postcodes where !addresses.contains(item.townAndCounty) {
            addresses.append(item.townAndCounty)
        }
        addresses.sort()
        return addresses
    }

    private func lookup(prefix: String) -> [String] {
        let filteredAddresses = addresses.filter { $0.hasCaseAndDiacriticInsensitivePrefix(prefix) }
        return filteredAddresses
    }
}
