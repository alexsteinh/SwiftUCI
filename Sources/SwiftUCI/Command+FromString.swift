public extension Command {
    init?(string: String) {
        if let command = Self.parseCommand(tokenizer: .init(string: string)) {
            self = command
        } else {
            return nil
        }
    }
    
    // TODO: Implement for 'GUI to Engine' commands
    private static func parseCommand(tokenizer: CommandTokenizer) -> Command? {
        switch tokenizer.nextString() {
        case "id":
            parseId(tokenizer: tokenizer)
        case "uciok":
            Command.uciok
        case "readyok":
            Command.readyok
        case "bestmove":
            parseBestmove(tokenizer: tokenizer)
        case "copyprotection":
            parseCopyprotection(tokenizer: tokenizer)
        case "registration":
            parseRegistration(tokenizer: tokenizer)
        case "info":
            parseInfo(tokenizer: tokenizer)
        case "option":
            parseOption(tokenizer: tokenizer)
        default:
            nil
        }
    }
    
    private static func parseId(tokenizer: CommandTokenizer) -> Command? {
        switch tokenizer.nextString() {
        case "name":
            Command.id(.name(tokenizer.remainingString))
        case "author":
            Command.id(.author(tokenizer.remainingString))
        default:
            nil
        }
    }
    
    private static func parseBestmove(tokenizer: CommandTokenizer) -> Command? {
        guard let move1 = tokenizer.nextString().flatMap(Move.init(string:)) else {
            return nil
        }
        
        let move2: Move?
        if let next = tokenizer.nextString() {
            if next == "ponder", let ponderMove = tokenizer.nextString().flatMap(Move.init(string:)) {
                move2 = ponderMove
            } else {
                return nil
            }
        } else {
            move2 = nil
        }
        
        return .bestmove(move1, ponder: move2)
    }
    
    private static func parseCopyprotection(tokenizer: CommandTokenizer) -> Command? {
        tokenizer.nextString().flatMap { .copyprotection($0) }
    }
    
    private static func parseRegistration(tokenizer: CommandTokenizer) -> Command? {
        tokenizer.nextString().flatMap { .registration($0) }
    }
    
    private static func parseInfo(tokenizer: CommandTokenizer) -> Command? {
        var arguments = Set<InfoArgument>()
        
        while let token = tokenizer.nextString() {
            switch token {
            case "depth":
                if let int = tokenizer.nextInt() {
                    arguments.insert(.depth(int))
                }
            case "seldepth":
                if let int = tokenizer.nextInt() {
                    arguments.insert(.seldepth(int))
                }
            case "time":
                if let int = tokenizer.nextInt() {
                    arguments.insert(.time(int))
                }
            case "nodes":
                if let int = tokenizer.nextInt() {
                    arguments.insert(.nodes(int))
                }
            case "pv":
                var moves = [Move]()
                
                while true {
                    if let move = tokenizer.nextString().flatMap(Move.init(string:)) {
                        moves.append(move)
                    } else {
                        tokenizer.undo()
                        break
                    }
                }
                
                arguments.insert(.pv(moves))
            case "multipv":
                if let int = tokenizer.nextInt() {
                    arguments.insert(.multipv(int))
                }
            case "score":
                var scoreArguments = Set<InfoArgument.ScoreArgument>()
                
                loop: while true {
                    switch tokenizer.nextString() {
                    case "cp":
                        if let int = tokenizer.nextInt() {
                            scoreArguments.insert(.cp(int))
                        }
                    case "mate":
                        if let int = tokenizer.nextInt() {
                            scoreArguments.insert(.mate(int))
                        }
                    case "lowerbound":
                        scoreArguments.insert(.lowerbound)
                    case "upperbound":
                        scoreArguments.insert(.upperbound)
                    default:
                        tokenizer.undo()
                        break loop
                    }
                }
                
                arguments.insert(.score(scoreArguments))
            case "currmove":
                if let move = tokenizer.nextString().flatMap(Move.init(string:)) {
                    arguments.insert(.currmove(move))
                }
            case "currmovenumber":
                if let int = tokenizer.nextInt() {
                    arguments.insert(.currmovenumber(int))
                }
            case "hashfull":
                if let int = tokenizer.nextInt() {
                    arguments.insert(.hashfull(int))
                }
            case "nps":
                if let int = tokenizer.nextInt() {
                    arguments.insert(.nps(int))
                }
            case "tbhits":
                if let int = tokenizer.nextInt() {
                    arguments.insert(.tbhits(int))
                }
            case "sbhits":
                if let int = tokenizer.nextInt() {
                    arguments.insert(.sbhits(int))
                }
            case "cpuload":
                if let int = tokenizer.nextInt() {
                    arguments.insert(.cpuload(int))
                }
            case "string":
                if let string = tokenizer.nextString() {
                    arguments.insert(.string(string))
                }
            case "refutation":
                if let move1 = tokenizer.nextString().flatMap(Move.init(string:)) {
                    var moves = [Move]()
                    
                    loop: while let string = tokenizer.nextString() {
                        if let move = Move(string: string) {
                            moves.append(move)
                        } else {
                            tokenizer.undo()
                            break loop
                        }
                    }
                    
                    arguments.insert(.refutation(move1, moves))
                }
            case "currline":
                if let cpunr = tokenizer.nextInt() {
                    var moves = [Move]()
                    
                    loop: while let string = tokenizer.nextString() {
                        if let move = Move(string: string) {
                            moves.append(move)
                        } else {
                            tokenizer.undo()
                            break loop
                        }
                    }
                    
                    arguments.insert(.currline(cpunr, moves))
                }
            default:
                break
            }
        }
        
        return .info(arguments)
    }
    
    private static func parseOption(tokenizer: CommandTokenizer) -> Command? {
        let keywords = Set<String>(arrayLiteral: "name", "type", "default", "min", "max", "var")
        
        var nameComponents: [String] = []
        var typeString: String? = nil
        var defaultValue: String? = nil
        var minValue: String? = nil
        var maxValue: String? = nil
        var varValues: [String] = []
        
        while let string = tokenizer.nextString() {
            switch string {
            case "name":
                while let string = tokenizer.nextString() {
                    guard !keywords.contains(string) else {
                        tokenizer.undo()
                        break
                    }
                    
                    nameComponents.append(string)
                }
            case "type":
                typeString = tokenizer.nextString()
            case "default":
                defaultValue = tokenizer.nextString()
            case "min":
                minValue = tokenizer.nextString()
            case "max":
                maxValue = tokenizer.nextString()
            case "var":
                if let value = tokenizer.nextString() {
                    varValues.append(value)
                }
            default:
                break
            }
        }
        
        let name = nameComponents.joined(separator: " ")
        guard !name.isEmpty else {
            return nil
        }
        
        switch typeString {
        case "check":
            if let defaultValue {
                return .option(name: name, type: .check(default: defaultValue == "true"))
            }
        case "spin":
            if let defaultValue = defaultValue.flatMap(Int.init), let minValue = minValue.flatMap(Int.init), let maxValue = maxValue.flatMap(Int.init) {
                return .option(name: name, type: .spin(default: defaultValue, min: minValue, max: maxValue))
            }
        case "combo":
            if let defaultValue, !varValues.isEmpty {
                return .option(name: name, type: .combo(default: defaultValue, vars: varValues))
            }
        case "string":
            if let defaultValue {
                return .option(name: name, type: .string(default: defaultValue))
            }
        case "button":
            return .option(name: name, type: .button)
        default:
            break
        }
        
        return nil
    }
}
