//
//  Move.swift
//
//
//  Created by Alexander Steinhauer on 06.10.23.
//

public struct Move: Hashable {
    public let from: String
    public let to: String
    public let promoted: Bool
    
    init(from: String, to: String, promoted: Bool) {
        self.from = from
        self.to = to
        self.promoted = promoted
    }
}
