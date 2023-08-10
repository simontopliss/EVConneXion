//
//  UserSettings.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 30/07/2023.
//

import Foundation

struct UserSettings: Identifiable, Codable {
    let id: UUID
//    var dataName: String
//    var displayName: String
//    var symbol: String
//    var setting: Bool
//    var userSetting: Bool
}

extension UserSettings {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
//        case dataName    = "DataName"
//        case displayName = "DisplayName"
//        case symbol      = "Symbol"
//        case setting     = "Setting"
    }
}

extension UserSettings {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        //        dataName      = try container.decode(String.self, forKey: .dataName)
        //        displayName   = try container.decode(String.self, forKey: .displayName)
        //        symbol        = try container.decode(String.self, forKey: .symbol)
//        do {
//            setting = try (container.decode(Int.self, forKey: .setting)) == 1 ? true : false
//        } catch {
//            setting = try container.decode(Bool.self, forKey: .setting)
//        }
    }
}

extension UserSettings {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
//        try container.encode(self.dataName, forKey: .dataName)
//        try container.encode(self.displayName, forKey: .displayName)
//        try container.encode(self.symbol, forKey: .symbol)
//        try container.encode(self.setting, forKey: .setting)
    }
}

extension UserSettings {
    func saveData() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            encoder.outputFormatting = .prettyPrinted

            let data = try? encoder.encode(self)

            let savePath = FileManager.documentsDirectory
                .appendingPathComponent("UserSettings")
                .appendingPathExtension("json")

            try data?.write(to: savePath, options: [.atomic, .completeFileProtection])

        } catch {
            print(error)
        }
    }
}
