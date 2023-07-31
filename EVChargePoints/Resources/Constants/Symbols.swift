//
//  Symbols.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 17/07/2023.
//

import SwiftUI

enum Symbols {
    static let genericNetwork = Image(systemName: "network")

    static let evChargerName = "bolt.circle.fill" // "ev.charger.fill"
    static let evCharger = Image(systemName: evChargerName)

    static let yes = "✅"
    static let no = "❌"

    //TODO: Move these to JSON file
    static let accessSymbol = Image(systemName: "parkingsign.circle")
    static let connectorSymbol = Image(systemName: "ev.plug.ac.type.2")
    static let locationSymbol = Image(systemName: "mappin.and.ellipse.circle")
    static let networkSymbol = Image(systemName: "network")
    static let chargerSymbol = Image(systemName: "bolt.circle")

    //TODO: Move these to JSON file
    /// Access Symbols
    static let access24HoursSymbol = Image(systemName: "24.circle")
    static let accessRestrictionSymbol = Image(systemName: "slash.circle")
    static let onStreetSymbol = Image(systemName: "road.lanes")
    static let parkingFeesSymbol = Image(systemName: "parkingsign.circle")
    static let physicalRestrictionSymbol = Image(systemName: "wrongwaysign")
}
