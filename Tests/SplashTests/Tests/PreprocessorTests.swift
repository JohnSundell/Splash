/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest
import Splash

final class PreprocessorTests: SyntaxHighlighterTestCase {
    func testPreprocessing() {
        let components = highlighter.highlight("""
        #if os(iOS)
        call()
        #endif
        """)

        XCTAssertEqual(components, [
            .token("#if", .preprocessing),
            .whitespace(" "),
            .token("os(iOS)", .preprocessing),
            .whitespace("\n"),
            .token("call", .call),
            .plainText("()"),
            .whitespace("\n"),
            .token("#endif", .preprocessing)
        ])
    }

    func testSelector() {
        let components = highlighter.highlight("addObserver(self, selector: #selector(function(_:)))")

        XCTAssertEqual(components, [
            .token("addObserver", .call),
            .plainText("("),
            .token("self", .keyword),
            .plainText(","),
            .whitespace(" "),
            .plainText("selector:"),
            .whitespace(" "),
            .token("#selector", .keyword),
            .plainText("("),
            .token("function", .call),
            .plainText("("),
            .token("_", .keyword),
            .plainText(":)))")
        ])
    }

    func testFunctionAttribute() {
        let components = highlighter.highlight("@NSApplicationMain class AppDelegate {}")

        XCTAssertEqual(components, [
            .token("@NSApplicationMain", .keyword),
            .whitespace(" "),
            .token("class", .keyword),
            .whitespace(" "),
            .plainText("AppDelegate"),
            .whitespace(" "),
            .plainText("{}")
        ])
    }

    func testAvailabilityCheck() {
        let components = highlighter.highlight("if #available(iOS 13, *) {}")

        XCTAssertEqual(components, [
            .token("if", .keyword),
            .whitespace(" "),
            .token("#available", .keyword),
            .plainText("(iOS"),
            .whitespace(" "),
            .token("13", .number),
            .plainText(","),
            .whitespace(" "),
            .plainText("*)"),
            .whitespace(" "),
            .plainText("{}")
        ])
    }

    func testAllTestsRunOnLinux() {
        XCTAssertTrue(TestCaseVerifier.verifyLinuxTests((type(of: self)).allTests))
    }
}

extension PreprocessorTests {
    static var allTests: [(String, TestClosure<PreprocessorTests>)] {
        return [
            ("testPreprocessing", testPreprocessing),
            ("testSelector", testSelector),
            ("testFunctionAttribute", testFunctionAttribute),
            ("testAvailabilityCheck", testAvailabilityCheck)
        ]
    }
}
