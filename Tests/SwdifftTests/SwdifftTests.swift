import XCTest
@testable import Swdifft

final class SwdifftTests: XCTestCase {
    func testFormatDiff() {
        let result = formatDiff("ABCDEFG", "BEACGF")
        let l = "A\(beginLHSMark)B\(endLHSMark)C\(beginLHSMark)DE\(endLHSMark)F\(beginLHSMark)G\(endLHSMark)"
        let r = "\(beginRHSMark)BE\(endRHSMark)AC\(beginRHSMark)G\(endRHSMark)F"
        XCTAssertEqual(result, "\(l)\n\(r)")
    }
    
    func testDiff() {
        XCTContext.runActivity(named: "When same argument", block: { _ in
            let result = diff("ABCDEFG", "ABCDEFG")
            XCTAssertEqual(result.lhs, "ABCDEFG")
            XCTAssertEqual(result.rhs, "ABCDEFG")
        })
        XCTContext.runActivity(named: "When lhs > rhs", block: { _ in
            let result = diff("ABCDEFGHIJ", "ABCDEFG")
            XCTAssertEqual(result.lhs, "ABCDEFG\(beginLHSMark)HIJ\(endLHSMark)")
            XCTAssertEqual(result.rhs, "ABCDEFG")
        })
        XCTContext.runActivity(named: "When lhs < rhs", block: { _ in
            let result = diff("ABCDEFG", "ABCDEFGHIJ")
            XCTAssertEqual(result.lhs, "ABCDEFG")
            XCTAssertEqual(result.rhs, "ABCDEFG\(beginRHSMark)HIJ\(endRHSMark)")
        })
        XCTContext.runActivity(named: "Longest Common Subsequence is ACF", block: { _ in
            let result = diff("ABCDEFG", "BEACGF")
            XCTAssertEqual(result.lhs, "A\(beginLHSMark)B\(endLHSMark)C\(beginLHSMark)DE\(endLHSMark)F\(beginLHSMark)G\(endLHSMark)")
            XCTAssertEqual(result.rhs, "\(beginRHSMark)BE\(endRHSMark)AC\(beginRHSMark)G\(endRHSMark)F")
        })
    }
    
    
    func testLongestCommonSubsequence() {
        XCTContext.runActivity(named: "When same argument", block: { _ in
            let result = longestCommonSubsequence(lhs: "ABCDEFG", rhs: "ABCDEFG")
            XCTAssertEqual(result, "ABCDEFG")
        })
        XCTContext.runActivity(named: "When lhs > rhs", block: { _ in
            let result = longestCommonSubsequence(lhs: "ABCDEFGHIJ", rhs: "ABCDEFG")
            XCTAssertEqual(result, "ABCDEFG")
        })
        XCTContext.runActivity(named: "When lhs < rhs", block: { _ in
            let result = longestCommonSubsequence(lhs: "ABCDEFG", rhs: "ABCDEFGHIJ")
            XCTAssertEqual(result, "ABCDEFG")
        })
        XCTContext.runActivity(named: "Expected to get ACF ", block: { _ in
            let result = longestCommonSubsequence(lhs: "ABCDEFG", rhs: "BEACGF")
            XCTAssertEqual(result, "ACF")
        })
    }
    
}
