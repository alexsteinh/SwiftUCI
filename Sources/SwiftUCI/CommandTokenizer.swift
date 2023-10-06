//
//  CommandTokenizer.swift
//
//
//  Created by Alexander Steinhauer on 06.10.23.
//

final class CommandTokenizer {
    private let tokens: [String]
    private var index: Array.Index
    
    init(string: String) {
        tokens = string.split(separator: /\s+/).map(String.init)
        index = tokens.startIndex
    }
    
    func nextString() -> String? {
        guard let string = tokens[safeIndex: index] else {
            return nil
        }
        
        index += 1
        return string
    }
    
    func nextInt() -> Int? {
        guard let int = tokens[safeIndex: index].flatMap({ Int($0) }) else {
            return nil
        }
        
        index += 1
        return int
    }
    
    func undo() {
        index = max(tokens.startIndex, index - 1)
    }
    
    var remainingString: String {
        tokens[index...].joined(separator: " ")
    }
}
