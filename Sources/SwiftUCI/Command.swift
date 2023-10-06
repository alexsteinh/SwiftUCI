//
//  Command.swift
//
//
//  Created by Alexander Steinhauer on 05.10.23.
//

public enum Command {
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
    
    public enum PositionArgument {
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
    
    public enum IdArgument {
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
