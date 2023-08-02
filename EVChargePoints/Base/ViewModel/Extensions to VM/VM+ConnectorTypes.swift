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
}
