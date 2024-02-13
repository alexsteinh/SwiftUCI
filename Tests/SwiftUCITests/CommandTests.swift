import XCTest
@testable import SwiftUCI

final class CommandTests: XCTestCase {
    private func isEqual(_ string: String, _ command: Command?, checkIdentity: Bool = true, file: StaticString = #file, line: UInt = #line) {
        let parsedCommand = Command(string: string)
        XCTAssertEqual(command, parsedCommand)
        
        if checkIdentity, let parsedCommand {
            XCTAssertEqual("\(parsedCommand)", string, file: file, line: line)
        }
    }
    
    func testUci() {
        isEqual("uci", .uci)
    }
    
    func testDebug() {
        isEqual("debug on", .debug(true))
        isEqual("debug off", .debug(false))
        isEqual("debug", nil)
    }
    
    func testIsready() {
        isEqual("isready", .isready)
    }
    
    func testSetoption() {
        isEqual("setoption name Nullmove value true", .setoption(name: "Nullmove", value: "true"))
        isEqual("setoption name Clear Hash", .setoption(name: "Clear Hash", value: nil))
        isEqual("setoption value false", nil)
    }
    
    func testRegister() {
        isEqual("register later", .register([.later]))
        isEqual("register name AS", .register([.name("AS")]))
        isEqual("register code SECRET_CODE", .register([.code("SECRET_CODE")]))
        isEqual("register name AS code SECRET_CODE", .register([.name("AS"), .code("SECRET_CODE")]), checkIdentity: false)
    }
    
    func testUcinewgame() {
        isEqual("ucinewgame", .ucinewgame)
    }
    
    func testPosition() {
        isEqual("position startpos", .position(.startpos, moves: []))
        isEqual("position fen FEN", .position(.fen("FEN"), moves: []))
        isEqual("position startpos moves d2d4 d7d5", .position(.startpos, moves: [.init(from: "d2", to: "d4"), .init(from: "d7", to: "d5")]))
    }
    
    func testGo() {
        isEqual("go searchmoves d2d4", .go([.searchmoves([.init(from: "d2", to: "d4")])]))
        isEqual("go ponder", .go([.ponder]))
        isEqual("go wtime 1000", .go([.wtime(1000)]))
        isEqual("go btime 1000", .go([.btime(1000)]))
        isEqual("go winc 1000", .go([.winc(1000)]))
        isEqual("go binc 1000", .go([.binc(1000)]))
        isEqual("go movestogo 1", .go([.movestogo(1)]))
        isEqual("go depth 1", .go([.depth(1)]))
        isEqual("go nodes 1", .go([.nodes(1)]))
        isEqual("go mate 1", .go([.mate(1)]))
        isEqual("go movetime 1", .go([.movetime(1)]))
        isEqual("go infinite", .go([.infinite]))
        isEqual("go searchmoves d2d4 ponder wtime 3000 btime 5000 winc 1000 binc 1000 movestogo 1 depth 2 nodes 5 mate 1 movetime 5000 infinite", .go([.searchmoves([.init(from: "d2", to: "d4")]), .ponder, .wtime(3000), .btime(5000), .winc(1000), .binc(1000), .movestogo(1), .depth(2), .nodes(5), .mate(1), .movetime(5000), .infinite]), checkIdentity: false)
    }
    
    func testStop() {
        isEqual("stop", .stop)
    }
    
    func testPonderhit() {
        isEqual("ponderhit", .ponderhit)
    }
    
    func testQuit() {
        isEqual("quit", .quit)
    }
    
    func testId() {
        isEqual("id author AS", .id(.author("AS")))
        isEqual("id name AS", .id(.name("AS")))
        isEqual("id name AS Chess Engine", .id(.name("AS Chess Engine")))
        isEqual("id bogus", nil)
    }
    
    func testOk() {
        isEqual("uciok", .uciok)
        isEqual("readyok", .readyok)
    }
    
    func testBestmove() {
        isEqual("bestmove e2e4", .bestmove(.init(from: "e2", to: "e4"), ponder: nil))
        isEqual("bestmove e2e4 ponder d2d4", .bestmove(.init(from: "e2", to: "e4"), ponder: .init(from: "d2", to: "d4")))
        isEqual("bestmove e2e4 bogus d2d4", nil)
    }
    
    func testCopyright() {
        isEqual("copyprotection ok", .copyprotection("ok"))
        isEqual("registration ok", .registration("ok"))
    }
    
    func testInfo() {
        isEqual("info depth 1", .info([.depth(1)]))
        isEqual("info seldepth 1", .info([.seldepth(1)]))
        isEqual("info multipv 1", .info([.multipv(1)]))
        isEqual("info score cp 30", .info([.score([.cp(30)])]))
        isEqual("info score mate 8", .info([.score([.mate(8)])]))
        isEqual("info score lowerbound", .info([.score([.lowerbound])]))
        isEqual("info score upperbound", .info([.score([.upperbound])]))
        isEqual("info depth 34 seldepth 40 multipv 1 score cp 30 lowerbound nodes 20634975 nps 832794 hashfull 1000 tbhits 0 time 24778 pv e2e4", .info([.depth(34), .seldepth(40), .multipv(1), .score([.cp(30), .lowerbound]), .nodes(20634975), .nps(832794), .hashfull(1000), .tbhits(0), .time(24778), .pv([.init(from: "e2", to: "e4")])]), checkIdentity: false)
    }
    
    func testOption() {
        isEqual("option name Nullmove type check default true", .option(name: "Nullmove", type: .check(default: true)))
        isEqual("option name Selectivity type spin default 2 min 0 max 4", .option(name: "Selectivity", type: .spin(default: 2, min: 0, max: 4)))
        isEqual("option name Style type combo default Normal var Solid var Normal var Risky", .option(name: "Style", type: .combo(default: "Normal", vars: ["Solid", "Normal", "Risky"])))
        isEqual("option name NalimovPath type string default c:\\", .option(name: "NalimovPath", type: .string(default: "c:\\")))
        isEqual("option name Clear Hash type button", .option(name: "Clear Hash", type: .button))
        isEqual("option name Nullmove type chec default true", nil)
    }
    
    func testWhitespaceNormalization() {
        isEqual("\tid  name   \t\t\tImaginery\tChess Engine   ", .id(.name("Imaginery Chess Engine")), checkIdentity: false)
    }
}
