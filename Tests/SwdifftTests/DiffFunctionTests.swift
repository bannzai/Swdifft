//
//  DiffFunctionTests.swift
//  SwdifftTests
//
//  Created by Yudai Hirose on 2019/07/13.
//

import XCTest
@testable import Swdifft

class DiffFunctionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDiff() {
        XCTContext.runActivity(named: "When rhs is insufficient", block: { _ in
            let result = diff("Hello world", "Hello")
            XCTAssertEqual(
                result.description,
                """
"""
            )
        })
        XCTContext.runActivity(named: "When lhs is insufficient", block: { _ in
            let result = diff("Hello", "Hello world")
            XCTAssertEqual(
                result.description,
                """
"""
            )
        })
        XCTContext.runActivity(named: "When lhs and rhs same length but difference", block: { _ in
            let result = diff("Hello", "Hello world")
            XCTAssertEqual(
                result.description,
                """
"""
            )
        })
        XCTContext.runActivity(named: "When rhs is insufficient for line", block: { _ in
            let result = diff(
                """
Hello world 1
Hello world 2
""",
                """
Hello world 2
"""
            )
            XCTAssertEqual(
                result.description,
                """
"""
            )
        })
        XCTContext.runActivity(named: "When lhs is insufficient for line", block: { _ in
            let result = diff(
                """
Hello world 2
""",
                """
Hello world 1
Hello world 2
"""
            )
            XCTAssertEqual(
                result.description,
                """
"""
            )
        })
        XCTContext.runActivity(named: "When it is exists many difference between lhs and rhs", block: { _ in
            let result = diff(
                "Hello world bannzai",
                "Holly shit bannnzai"
            )
            XCTAssertEqual(
                result.description,
                """
"""
            )
        })
    }

}
