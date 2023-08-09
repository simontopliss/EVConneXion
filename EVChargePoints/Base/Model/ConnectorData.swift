//
//  ConnectorData.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct ConnectorData: Identifiable, Codable {
    let id = UUID()
    var connectorType: ConnectorType
    var displayName: String
    var graphicName: String
    var setting: Bool
}

extension ConnectorData {
    enum CodingKeys: String, CodingKey {
        case connectorType  = "ConnectorType"
        case displayName    = "DisplayName"
        case graphicName    = "GraphicName"
        case setting        = "Setting"
    }
}

extension ConnectorData {
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        connectorType  = try container.decode(ConnectorType.self, forKey: .connectorType)
        displayName    = try container.decode(String.self, forKey: .displayName)
        graphicName    = try container.decode(String.self, forKey: .graphicName)
        setting        = try (container.decode(Int.self, forKey: .setting)) == 1 ? true : false
    }
}

extension ConnectorData {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.setting, forKey: .setting)
    }
}
