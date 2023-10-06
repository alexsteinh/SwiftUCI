public struct Move: Hashable {
    public let from: String
    public let to: String
    public let promotion: String?
    
    init(from: String, to: String, promotion: String? = nil) {
        self.from = from
        self.to = to
        self.promotion = promotion
    }
}

extension Move: CustomStringConvertible {
    public var description: String {
        "\(from)\(to)\(promotion ?? "")"
    }
}

extension Move {
    init?(string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Handle special nullmove
        if trimmedString == "0000" {
            self.init(from: "00", to: "00", promotion: nil)
        }
        
        guard let (_, from, to, promotion) = trimmedString.wholeMatch(of: /([a-h][1-8])([a-h][1-8])(q|r|b|n)?/)?.output else {
            return nil
        }
        
        self.init(from: String(from), to: String(to), promotion: promotion.flatMap(String.init))
    }
}
