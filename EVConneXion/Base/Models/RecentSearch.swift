//
//  RecentSearch.swift
//  EVConneXion
//
//  Created by Simon Topliss on 15/08/2023.
//

import Foundation

struct RecentSearch: Identifiable, Codable {
    let id = UUID()
    var searchQuery: String
}

extension RecentSearch {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case searchQuery = "SearchQuery"
    }
}

extension RecentSearch {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.searchQuery = try container.decode(String.self, forKey: .searchQuery)
    }
}

extension RecentSearch {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.searchQuery, forKey: .searchQuery)
    }
}

extension RecentSearch {
    static func saveData(data: [RecentSearch]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            encoder.outputFormatting = .prettyPrinted

            let data = try? encoder.encode(data)

            let savePath = FileManager.documentsDirectory
                .appendingPathComponent(EVConneXionApp.JSONFiles.recentSearches.rawValue)
                .appendingPathExtension("json")

            try data?.write(to: savePath, options: [.atomic, .completeFileProtection])

        } catch {
            print(error)
        }
    }
}
