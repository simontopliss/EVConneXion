//
//  DataManager+Search.swift
//  EVConneXion
//
//  Created by Simon Topliss on 12/08/2023.
//

import Foundation

extension DataManager {

    @MainActor
    func searchForChargeDevices(searchQuery: String) async throws {
        // print(#function)

        var searchQuery = searchQuery.trim()

        do {
            if try !isSearchQueryValid(searchQuery: searchQuery) { return }
        } catch {
            print(error)
        }

        isPostcode(postcode: searchQuery)
        ? await fetchChargeDevices(requestType: .postcode(searchQuery.localizedUppercase))
        : await fetchChargeDevices(requestType: .postTown(searchQuery))

        if (networkError == nil) {
            let result = recentSearches.filter { $0.searchQuery == searchQuery }
            if result.isEmpty {
                recentSearches.insert(RecentSearch(searchQuery: searchQuery), at: 0)
                saveSettings(.recentSearches)
            }
            searchQuery = ""
        }
    }

    // TODO: Add unit tests to confirm this works
    func isPostcode(postcode: String) -> Bool {
        return postcode.localizedUppercase.firstMatch(of: /^[A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}$/) != nil
    }

    /*
     This version checks the postcode pattern, not just the format
     See: https://stackoverflow.com/questions/164979/regex-for-matching-uk-postcodes
     /^(([A-Z]{1,2}\d[A-Z\d]?|ASCN|STHL|TDCU|BBND|[BFS]IQQ|PCRN|TKCA) ?\d[A-Z]{2}|BFPO ?\d{1,4}|(KY\d|MSR|VG|AI)[ -]?\d{4}|[A-Z]{2} ?\d{2}|GE ?CX|GIR ?0A{2}|SAN ?TA1)$/
     */

    /*
     This version will also accept a postcode without a space between the two parts
     /^(([A-Z][0-9]{1,2})|(([A-Z][A-HJ-Y][0-9]{1,2})|(([A-Z][0-9][A-Z])|([A-Z][A-HJ-Y][0-9]?[A-Z])))) ?[0-9][A-Z]{2}$/
     */

    private func isSearchQueryValid(searchQuery: String) throws -> Bool {
        if searchQuery.isEmpty { return false }
        if searchQuery.count < 3 { // Is this min correct?
            throw SearchError.invalidPostcode
        }

        return true
    }

    enum SearchError: LocalizedError {
        case invalidPostcode
        case noResults
        case custom(error: Error)

        var errorDescription: String? {
            switch self {
                case .invalidPostcode:
                    return "Invalid postcode"
                case .noResults:
                    return "No results"
                case let .custom(error: error):
                    return "Something went wrong;  \(error.localizedDescription)"
            }
        }
    }
}
