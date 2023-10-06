//
//  Collection+Extensions.swift
//
//
//  Created by Alexander Steinhauer on 06.10.23.
//

extension Collection {
    subscript(safeIndex index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
