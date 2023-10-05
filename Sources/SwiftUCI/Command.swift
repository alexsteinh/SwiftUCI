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
    case register
    case ucinewgame
    case position(PositionArgument?, moves: [Move])
    case go(Set<GoArgument>)
    case stop
    case ponderhit
    case quit
    
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
    case bestmove(Move, ponder: Move)
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
