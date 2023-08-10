//
//  VM+ConnectorData.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 27/07/2023.
//

import SwiftUI

extension DataManager {

    /// Loads the network graphics from a JSON file
    func loadConnectorTypes() {
        connectorData = try! StaticJSONMapper.decode(
            file: "ConnectorData",
            type: [ConnectorData].self,
            location: .documents
        )
    }

    func connectorGraphicFor(connectorType: String, colorScheme: ColorScheme) -> String {
        let item = connectorData.first { $0.connectorType.rawValue == connectorType }

        guard let graphicName = item?.graphicName else {
            // TODO: Should probably handle a missing graphic
            print("No connector graphic found for \(connectorType)")
            return "default-network"
        }

        return colorScheme == .dark ? graphicName + "-i" : graphicName
    }

    func displayNameFor(connectorType: String) -> String {
        let item = connectorData.first { $0.connectorType.rawValue == connectorType }

        guard let displayName = item?.displayName else {
            fatalError("No display name for for \(connectorType)")
        }

        return displayName
    }
}
