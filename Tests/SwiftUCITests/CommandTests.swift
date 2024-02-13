import XCTest
@testable import SwiftUCI

final class CommandTests: XCTestCase {
    private func isEqual(_ string: String, _ command: Command?) {
        XCTAssertEqual(command, Command(string: string))
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
        isEqual("register name AS code SECRET_CODE", .register([.name("AS"), .code("SECRET_CODE")]))
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
        isEqual("go searchmoves d2d4 ponder wtime 3000 btime 5000 winc 1000 binc 1000 movestogo 1 depth 2 nodes 5 mate 1 movetime 5000 infinite", .go([.searchmoves([.init(from: "d2", to: "d4")]), .ponder, .wtime(3000), .btime(5000), .winc(1000), .binc(1000), .movestogo(1), .depth(2), .nodes(5), .mate(1), .movetime(5000), .infinite]))
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
        isEqual("info depth 34 seldepth 40 multipv 1 score cp 30 lowerbound nodes 20634975 nps 832794 hashfull 1000 tbhits 0 time 24778 pv e2e4", .info([.depth(34), .seldepth(40), .multipv(1), .score([.cp(30), .lowerbound]), .nodes(20634975), .nps(832794), .hashfull(1000), .tbhits(0), .time(24778), .pv([.init(from: "e2", to: "e4")])]))
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
        isEqual("\tid  name   \t\t\tImaginery\tChess Engine   ", .id(.name("Imaginery Chess Engine")))
    }
}
