//
//  Sequence+uniqued.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/14.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
