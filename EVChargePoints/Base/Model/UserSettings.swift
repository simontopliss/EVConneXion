//
//  UserSettings.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct UserSettings: Identifiable, Codable {
    let id: UUID = UUID()
    var recentSearches: [String]?
    var unitSetting = "Miles"
    var country = "GB"
}

extension UserSettings {
    enum CodingKeys: String, CodingKey {
        case recentSearches = "RecentSearches"
        case unitSetting = "UnitSetting"
        case country = "Country"
    }
}

extension UserSettings {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recentSearches = try container.decodeIfPresent([String].self, forKey: .recentSearches)
        unitSetting = try container.decode(String.self, forKey: .unitSetting)
        country = try container.decode(String.self, forKey: .country)
    }
}

extension UserSettings {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(recentSearches, forKey: .recentSearches)
        try container.encode(unitSetting, forKey: .unitSetting)
        try container.encode(country, forKey: .country)
    }
}

extension UserSettings {
    static func saveData(data: UserSettings) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            encoder.outputFormatting = .prettyPrinted

            let data = try? encoder.encode(data)

            let savePath = FileManager.documentsDirectory
                .appendingPathComponent("UserSettings")
                .appendingPathExtension("json")

            try data?.write(to: savePath, options: [.atomic, .completeFileProtection])

        } catch {
            print(error)
        }
    }
}
