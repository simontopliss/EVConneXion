//
//  Sequence+Unique.swift
//  EVChargePoints
//
//  Created by Simon Topliss on 10/08/2023.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
