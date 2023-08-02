//
//  ConnectorData.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct ConnectorData: Identifiable {
    let id = UUID()
    var connector: String
    var dataName: String
    var displayName: String
    var graphicName: String
    var setting: Bool
}

extension ConnectorData {
    enum CodingKeys: String, CodingKey {
        case connector    = "Connector"
        case dataName     = "DataName"
        case displayName  = "DisplayName"
        case graphicName  = "GraphicName"
        case setting      = "Setting"
    }
}

extension ConnectorData: Decodable {
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        connector      = try container.decode(String.self, forKey: .connector)
        dataName       = try container.decode(String.self, forKey: .dataName)
        displayName    = try container.decode(String.self, forKey: .displayName)
        graphicName    = try container.decode(String.self, forKey: .graphicName)
        setting        = try (container.decode(Int.self, forKey: .setting)) == 1 ? true : false
    }
}
