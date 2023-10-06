import Foundation

public enum Command: Equatable {
    // MARK: - GUI to Engine
    
    case uci
    case debug(Bool)
    case isready
    case setoption(name: String, value: String?)
    case register(Set<RegistrationArgument>)
    case ucinewgame
    case position(PositionArgument?, moves: [Move])
    case go(Set<GoArgument>)
    case stop
    case ponderhit
    case quit
    
    public enum RegistrationArgument: Hashable {
        case later
        case name(String)
        case code(String)
    }
    
    public enum PositionArgument: Equatable {
        case fen(String)
        case startpos
    }
    
    public enum GoArgument: Hashable {
        case searchmoves([Move])
        case ponder
        case wtime(Int)
        case btime(Int)
        case winc(Int)
        case binc(Int)
        case movestogo(Int)
        case depth(Int)
        case nodes(Int)
        case mate(Int)
        case movetime(Int)
        case infinite
    }
    
    // MARK: - Engine to GUI
    
    case id(IdArgument)
    case uciok
    case readyok
    case bestmove(Move, ponder: Move?)
    case copyprotection(String)
    case registration(String)
    case info(Set<InfoArgument>)
    case option(name: String, type: OptionType)
    
    public enum IdArgument: Equatable {
        case name(String)
        case author(String)
    }
    
    public enum InfoArgument: Hashable {
        case depth(Int)
        case seldepth(Int)
        case time(Int)
        case nodes(Int)
        case pv([Move])
        case multipv(Int)
        case score(Set<ScoreArgument>)
        case currmove(Move)
        case currmovenumber(Int)
        case hashfull(Int)
        case nps(Int)
        case tbhits(Int)
        case sbhits(Int)
        case cpuload(Int)
        case string(String)
        case refutation(Move, [Move])
        case currline(Int, [Move])
        
        public enum ScoreArgument: Hashable {
            case cp(Int)
            case mate(Int)
            case lowerbound
            case upperbound
        }
    }
    
    public enum OptionType: Hashable {
        case check(default: Bool)
        case spin(default: Int, min: Int, max: Int)
        case combo(default: String, vars: [String])
        case string(default: String)
        case button
    }
}

// MARK: - Command to String

extension Command: CustomStringConvertible {
    public var description: String {
        switch self {
        case .uci:
            "uci"
        case .debug(let bool):
            "debug \(bool ? "on" : "off")"
        case .isready:
            "isready"
        case .setoption(let id, let value):
            buildString("setoption name \(id)") {
                if let value {
                    $0 += " value \(value)"
                }
            }
        case .register(let arguments):
            buildString("register") {
                for argument in arguments {
                    switch argument {
                    case .later:
                        $0 += " later"
                    case .name(let string):
                        $0 += " name \(string)"
                    case .code(let string):
                        $0 += " code \(string)"
                    }
                }
            }
        case .ucinewgame:
            "ucinewgame"
        case .position(let positionArgument, let moves):
            buildString("position") {
                switch positionArgument {
                case .fen(let string):
                    $0 += " fen \(string)"
                case .startpos:
                    $0 += " startpos"
                case nil:
                    break
                }
                
                $0 += buildString(" moves") {
                    for move in moves {
                        $0 += " \(move)"
                    }
                }
            }
        case .go(let arguments):
            buildString("go") {
                for argument in arguments {
                    switch argument {
                    case .searchmoves(let moves):
                        $0 += buildString(" searchmoves") {
                            for move in moves {
                                $0 += " \(move)"
                            }
                        }
                    case .ponder:
                        $0 += " ponder"
                    case .wtime(let int):
                        $0 += " wtime \(int)"
                    case .btime(let int):
                        $0 += " btime \(int)"
                    case .winc(let int):
                        $0 += " winc \(int)"
                    case .binc(let int):
                        $0 += " binc \(int)"
                    case .movestogo(let int):
                        $0 += " movestogo \(int)"
                    case .depth(let int):
                        $0 += " depth \(int)"
                    case .nodes(let int):
                        $0 += " nodes \(int)"
                    case .mate(let int):
                        $0 += " mate \(int)"
                    case .movetime(let int):
                        $0 += " movetime \(int)"
                    case .infinite:
                        $0 += " infinite"
                    }
                }
            }
        case .stop:
            "stop"
        case .ponderhit:
            "ponderhit"
        case .quit:
            "quit"
        case .id(let idArgument):
            switch idArgument {
            case .name(let string):
                "id name \(string)"
            case .author(let string):
                "id author \(string)"
            }
        case .uciok:
            "uciok"
        case .readyok:
            "readyok"
        case .bestmove(let move, let ponder):
            buildString("bestmove \(move)") {
                if let ponder {
                    $0 += " ponder \(ponder)"
                }
            }
        case .copyprotection(let string):
            "copyprotection \(string)"
        case .registration(let string):
            "registration \(string)"
        case .info(let arguments):
            buildString("info") {
                for argument in arguments {
                    switch argument {
                    case .depth(let int):
                        $0 += " depth \(int)"
                    case .seldepth(let int):
                        $0 += " seldepth \(int)"
                    case .time(let int):
                        $0 += " time \(int)"
                    case .nodes(let int):
                        $0 += " nodes \(int)"
                    case .pv(let moves):
                        $0 += buildString(" pv") {
                            for move in moves {
                                $0 += " \(move)"
                            }
                        }
                    case .multipv(let int):
                        $0 += " multipv \(int)"
                    case .score(let arguments):
                        $0 += buildString(" score") {
                            for argument in arguments {
                                switch argument {
                                case .cp(let int):
                                    $0 += " cp \(int)"
                                case .mate(let int):
                                    $0 += " mate \(int)"
                                case .lowerbound:
                                    $0 += " lowerbound"
                                case .upperbound:
                                    $0 += " upperbound"
                                }
                            }
                        }
                    case .currmove(let move):
                        $0 += " currmove \(move)"
                    case .currmovenumber(let int):
                        $0 += " currmovenumber \(int)"
                    case .hashfull(let int):
                        $0 += " hashfull \(int)"
                    case .nps(let int):
                        $0 += " nps \(int)"
                    case .tbhits(let int):
                        $0 += " tbhits \(int)"
                    case .sbhits(let int):
                        $0 += " sbhits \(int)"
                    case .cpuload(let int):
                        $0 += " cpuload \(int)"
                    case .string(let string):
                        $0 += " string \(string)"
                    case .refutation(let move, let moves):
                        $0 += buildString(" refutation \(move)") {
                            for move in moves {
                                $0 += " \(move)"
                            }
                        }
                    case .currline(let int, let moves):
                        $0 += buildString(" currline \(int)") {
                            for move in moves {
                                $0 += " \(move)"
                            }
                        }
                    }
                }
            }
        case .option(let name, let type):
            buildString("option name \(name)") {
                $0 += buildString(" type") {
                    switch type {
                    case .check(let `default`):
                        $0 += " check default \(`default`)"
                    case .spin(let `default`, let min, let max):
                        $0 += " spin default \(`default`) min \(min) max \(max)"
                    case .combo(let `default`, let vars):
                        $0 += buildString(" check \(`default`)") {
                            for opt in vars {
                                $0 += " var \(opt)"
                            }
                        }
                    case .string(let `default`):
                        $0 += " string default \(`default`)"
                    case .button:
                        $0 += " button"
                    }
                }
            }
        }
    }
}

// MARK: String to Command

extension Command {
    public init?(string: String) {
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
        if tokenizer.nextString() == "ponder" {
            if let ponderMove = tokenizer.nextString().flatMap(Move.init(string:)) {
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
