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
    
    func testMarkChange() {
        beginLHSMark = "%"
        endLHSMark = "%"
        beginRHSMark = "&"
        endRHSMark = "&"
        let result = formatDiff("ABCDEFG", "BEACGF")
        let l = "A%B%C%DE%F%G%"
        let r = "&BE&AC&G&F"
        XCTAssertEqual(result, "\(l)\n\(r)")
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
    
    func testMeasureDiff() {
        func randomString(_ length: Int) -> String {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in letters.randomElement()! })
        }

        XCTContext.runActivity(named: "baseline 2.5 sec", block: { _ in
            let length = 10000

            let a = randomString(length)
            let b = randomString(length)
            measure {
                _ = formatDiff(a, b)
            }
        })
    }
    
}
