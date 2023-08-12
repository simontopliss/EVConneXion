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
    var unitSetting: Unit = .mi
    var countrySetting: Country = .gb
    var distance: Double = 10.0
}

extension UserSettings {
    enum Unit: String, Codable, Identifiable {
        var id: Self { self }
        case mi = "Miles"
        case km = "Kilometres"
    }
}

extension UserSettings {
    enum Country: String, Codable, Identifiable {
        var id: Self { self }
        case gb = "United Kingdom"
        case ie = "Ireland"
    }
}

extension UserSettings {
    enum CodingKeys: String, CodingKey {
        case recentSearches  = "RecentSearches"
        case unitSetting     = "UnitSetting"
        case countrySetting  = "CountrySetting"
        case distance        = "Distance"
    }
}

extension UserSettings {
    init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: CodingKeys.self)
        recentSearches  = try container.decodeIfPresent([String].self, forKey: .recentSearches)
        unitSetting     = try container.decode(Unit.self, forKey: .unitSetting)
        countrySetting  = try container.decode(Country.self, forKey: .countrySetting)
        distance        = try container.decode(Double.self, forKey: .distance)
    }
}

extension UserSettings {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(recentSearches, forKey: .recentSearches)
        try container.encode(unitSetting, forKey: .unitSetting)
        try container.encode(countrySetting, forKey: .countrySetting)
        try container.encode(distance, forKey: .distance)
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
