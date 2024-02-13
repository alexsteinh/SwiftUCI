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
        // Handle special nullmove
        if string == "0000" {
            self.init(from: "00", to: "00", promotion: nil)
            return
        }
        
        guard let (_, from, to, promotion) = string.wholeMatch(of: /([a-h][1-8])([a-h][1-8])(q|r|b|n)?/)?.output else {
            return nil
        }
        
        self.init(from: String(from), to: String(to), promotion: promotion.flatMap(String.init))
    }
}
