import XCTest
@testable import SwiftUCI

final class CommandTests: XCTestCase {
    func testCommandFromString() {
        XCTAssertEqual(Command.id(.author("AS")), Command(string: "id author AS"))
        XCTAssertEqual(Command.id(.name("AS")), Command(string: "id name AS"))
        
        XCTAssertEqual(Command.uciok, Command(string: "uciok"))
        XCTAssertEqual(Command.readyok, Command(string: "readyok"))
        
        XCTAssertEqual(Command.bestmove(.init(from: "e2", to: "e4"), ponder: .init(from: "d2", to: "d4")), Command(string: "bestmove e2e4 ponder d2d4"))
        
        XCTAssertEqual(Command.copyprotection("ok"), Command(string: "copyprotection ok"))
        XCTAssertEqual(Command.registration("ok"), Command(string: "registration ok"))
        
        XCTAssertEqual(Command.info([.depth(34), .seldepth(40), .multipv(1), .score([.cp(30), .lowerbound]), .nodes(20634975), .nps(832794), .hashfull(1000), .tbhits(0), .time(24778), .pv([.init(from: "e2", to: "e4")])]), Command(string: "info depth 34 seldepth 40 multipv 1 score cp 30 lowerbound nodes 20634975 nps 832794 hashfull 1000 tbhits 0 time 24778 pv e2e4"))
        
        XCTAssertEqual(Command.option(name: "Nullmove", type: .check(default: true)), Command(string: "option name Nullmove type check default true"))
        XCTAssertEqual(Command.option(name: "Selectivity", type: .spin(default: 2, min: 0, max: 4)), Command(string: "option name Selectivity type spin default 2 min 0 max 4"))
        XCTAssertEqual(Command.option(name: "Style", type: .combo(default: "Normal", vars: ["Solid", "Normal", "Risky"])), Command(string: "option name Style type combo default Normal var Solid var Normal var Risky"))
        XCTAssertEqual(Command.option(name: "NalimovPath", type: .string(default: "c:\\")), Command(string: "option name NalimovPath type string default c:\\"))
        XCTAssertEqual(Command.option(name: "Clear Hash", type: .button), Command(string: "option name Clear Hash type button"))
    }
}
