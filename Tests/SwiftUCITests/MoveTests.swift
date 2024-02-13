import XCTest
@testable import SwiftUCI

final class MoveTests: XCTestCase {
    func testNullMove() {
        let move = Move(string: "0000")
        XCTAssertEqual(move?.from, "00")
        XCTAssertEqual(move?.to, "00")
        XCTAssertEqual(move?.promotion, nil)
    }
    
    func testNormalMove() {
        let move = Move(string: "e2e4")
        XCTAssertEqual(move?.from, "e2")
        XCTAssertEqual(move?.to, "e4")
        XCTAssertEqual(move?.promotion, nil)
    }
    
    func testBogusMove() {
        let move = Move(string: "e2e9")
        XCTAssertNil(move)
    }
    
    func testPromotionMove() {
        let move = Move(string: "e7e8q")
        XCTAssertEqual(move?.from, "e7")
        XCTAssertEqual(move?.to, "e8")
        XCTAssertEqual(move?.promotion, "q")
    }
}
