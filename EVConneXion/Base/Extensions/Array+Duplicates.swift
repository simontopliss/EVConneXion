//
//  Array+Duplicates.swift
//  EVConneXion
//
//  Created by Simon Topliss on 10/08/2023.
//

import Foundation

extension Array where Element: Hashable {
    func duplicates() -> Array {
        let groups = Dictionary(grouping: self, by: { $0 })
        let duplicateGroups = groups.filter { $1.count > 1 }
        let duplicates = Array(duplicateGroups.keys)
        return duplicates
    }
}
