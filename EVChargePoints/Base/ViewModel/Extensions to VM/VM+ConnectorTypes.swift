//
//  VM+ConnectorData.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 27/07/2023.
//

import SwiftUI

extension ChargePointViewModel {

    /// Loads the network graphics from a JSON file
    func loadConnectorTypes() {
        connectorData = try! StaticJSONMapper.decode(
            file: "ConnectorData",
            type: [ConnectorData].self
        )
    }

    func connectorGraphicFor(connectorType: String, colorScheme: ColorScheme) -> String {
        let item = connectorData.first { $0.dataName == connectorType }

        guard let graphicName = item?.graphicName else {
            // TODO: Should probably handle a missing graphic
            print("No connector graphic found for \(connectorType)")
            return "default-network-128"
        }

        return colorScheme == .dark ? graphicName + "-i" : graphicName
    }

    func displayNameFor(connectorType: String) -> String {
        let item = connectorData.first { $0.dataName == connectorType }

        guard let displayName = item?.displayName else {
            fatalError("No display name for for \(connectorType)")
        }

        return displayName
    }
}
