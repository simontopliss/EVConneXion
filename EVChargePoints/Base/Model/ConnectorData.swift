//
//  ConnectorData.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct ConnectorData: Identifiable, Codable {
    let id: UUID
    var connectorType: ConnectorType
    var displayName: String
    var graphicName: String
    var setting: Bool
}

extension ConnectorData {
    enum CodingKeys: String, CodingKey {
        case id             = "ID"
        case connectorType  = "ConnectorType"
        case displayName    = "DisplayName"
        case graphicName    = "GraphicName"
        case setting        = "Setting"
    }
}

extension ConnectorData {
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        id             = try container.decode(UUID.self, forKey: .id)
        connectorType  = try container.decode(ConnectorType.self, forKey: .connectorType)
        displayName    = try container.decode(String.self, forKey: .displayName)
        graphicName    = try container.decode(String.self, forKey: .graphicName)
        do {
            setting    = try (container.decode(Int.self, forKey: .setting)) == 1 ? true : false
        } catch {
            setting    = try container.decode(Bool.self, forKey: .setting)
        }
    }
}

extension ConnectorData {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(connectorType, forKey: .connectorType)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(graphicName, forKey: .graphicName)
        try container.encode(setting, forKey: .setting)
    }
}

extension ConnectorData {
    static func saveData(data: [ConnectorData]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            encoder.outputFormatting = .prettyPrinted

            let data = try? encoder.encode(data)

            let savePath = FileManager.documentsDirectory
                .appendingPathComponent("ConnectorData")
                .appendingPathExtension("json")

            try data?.write(to: savePath, options: [.atomic, .completeFileProtection])

        } catch {
            print(error)
        }
    }
}
