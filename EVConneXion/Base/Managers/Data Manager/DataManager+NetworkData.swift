//
//  VM+NetworkData.swift
//  EVConneXion
//
//  Created by Simon Topliss on 27/07/2023.
//

import SwiftUI

extension DataManager {

    /// Loads the network data from a JSON file
    func loadNetworkData() {
        // swiftlint:disable:next force_try
        self.networkData = try! StaticJSONMapper.decode(
            file: "NetworkData",
            type: [NetworkData].self,
            location: .documents
        )
        .sorted { $0.total > $1.total }
    }

    func networkColorFor(attribution: String) -> Color {
        // print(#function)
        return networkColorFor(network: attribution) ?? Color.accentColor
    }

    func networkColorFor(network: String) -> Color? {
        // print(#function)
        var item = networkData.first { $0.network == network }
        guard let networkColor = item?.networkColor else { return nil }

        return networkColor
    }

    /// Gets the shortened display name for a network
    /// - Parameter network: network String
    /// - Returns: the shorter display name from NetworkData.json
    func displayNameFor(network: String) -> String {
        let item = networkData.first { $0.network == network }

        guard let displayName = item?.displayName else { return network }
        return displayName
    }

    /// Description returns the svg or png for a given attribution
    /// - Parameter network: network String
    /// - Returns: name of the corresponding network graphic from NetworkData.json
    func networkGraphicFor(network: String) -> String {
        let item = networkData.first { $0.network == network }

        guard let filename = item?.graphicName else { return "default-network" }
        guard let fileURL = URL(string: filename) else {
            print("No network graphic found for \(network)")
            return "default-network"
        }
        return fileURL.deletingPathExtension().lastPathComponent
    }

    /// Returns the connector graphics and total for each connector
    /// - Parameter connectors: array connectors of a charge device
    /// - Returns: Array of structs of ConnectorGraphic
    func graphicsAndCountsFor(connectors: [Connector], colorScheme: ColorScheme) -> [ConnectorGraphic] {

        var connectorGraphics: [String] = []
        var connectorGraphicsAndCounts: [ConnectorGraphic] = []

        for connector in connectors {
            let connectorType = connector.connectorType.rawValue
            let graphicName = connectorGraphicFor(connectorType: connectorType, colorScheme: colorScheme)
            if connectorGraphics.contains(connectorType) {
                for index in 0..<connectorGraphicsAndCounts.count
                    where connectorGraphicsAndCounts[index].name == connectorType {
                    connectorGraphicsAndCounts[index].count += 1
                }
            } else {
                connectorGraphics.append(connectorType)
                connectorGraphicsAndCounts.append(ConnectorGraphic(
                    name: connectorType,
                    graphicName: graphicName,
                    count: 1
                ))
            }
        }

        return connectorGraphicsAndCounts
    }
}
