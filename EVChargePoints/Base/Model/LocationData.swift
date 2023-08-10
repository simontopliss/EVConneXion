//
//  AccessFilter.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct LocationData: Identifiable, Codable {
    let id: UUID
    var locationType: LocationType
    var displayName: String
    var graphicName: String
    var setting: Bool
}

extension LocationData {
    enum CodingKeys: String, CodingKey {
        case id          = "ID"
        case locationType = "LocationType"
        case displayName  = "DisplayName"
        case graphicName  = "GraphicName"
        case setting      = "Setting"
    }
}

extension LocationData {
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        id             = try container.decode(UUID.self, forKey: .id)
        locationType   = try container.decode(LocationType.self, forKey: .locationType)
        displayName    = try container.decode(String.self, forKey: .displayName)
        graphicName    = try container.decode(String.self, forKey: .graphicName)
        do {
            setting = try (container.decode(Int.self, forKey: .setting)) == 1 ? true : false
        } catch {
            setting = try container.decode(Bool.self, forKey: .setting)
        }
    }
}

extension LocationData {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.locationType, forKey: .locationType)
        try container.encode(self.displayName, forKey: .displayName)
        try container.encode(self.graphicName, forKey: .graphicName)
        try container.encode(self.setting, forKey: .setting)
    }
}

extension LocationData {
    static func saveData(data: [LocationData]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            encoder.outputFormatting = .prettyPrinted

            let data = try? encoder.encode(data)

            let savePath = FileManager.documentsDirectory
                .appendingPathComponent("LocationData")
                .appendingPathExtension("json")

            try data?.write(to: savePath, options: [.atomic, .completeFileProtection])

        } catch {
            print(error)
        }
    }
}
