//
//  Symbols.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import SwiftUI

enum Symbols {

    static let symbolWidth = 32.0
    static let symbolHeight = 32.0

    static let genericNetwork = Image(systemName: "network")

    static let evChargerName = "bolt.circle.fill" // "ev.charger.fill"
    static let evCharger = Image(systemName: evChargerName)

    static let yes = "✅"
    static let no = "❌"

    /// Navigation Link Symbols
    static let accessSymbol = Image(systemName: "parkingsign.circle")
    static let connectorSymbol = Image(systemName: "ev.plug.ac.type.2")
    static let locationSymbol = Image(systemName: "mappin.and.ellipse.circle")
    static let networkSymbol = Image(systemName: "network")
    static let chargerSymbol = Image(systemName: "bolt.circle")
    static let paymentSymbol = Image(systemName: "sterlingsign.circle")

    /// Map Symbols
    static let searchSymbol = Image(systemName: "location.magnifyingglass")
    static let noRecentSearchesSymbolName = "ev.charger.slash"
    static let noRecentSearchesSymbol = Image(systemName: noRecentSearchesSymbolName)

    /// User Settings Symbols
    static let unitSymbolName = "ruler"
    static let unitSymbol = Image(systemName: unitSymbolName)
    static let countrySymbolName = "map"
    static let countrySymbol = Image(systemName: countrySymbolName)
}
