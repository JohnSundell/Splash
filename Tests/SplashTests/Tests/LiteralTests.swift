/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest
import Splash

final class LiteralTests: SyntaxHighlighterTestCase {
    func testStringLiteral() {
        let components = highlighter.highlight("let string = \"Hello, world!\"")

        XCTAssertEqual(components, [
            .token("let", .keyword),
            .whitespace(" "),
            .plainText("string"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("\"Hello,", .string),
            .whitespace(" "),
            .token("world!\"", .string)
        ])
    }

    func testStringLiteralPassedToFunction() {
        let components = highlighter.highlight("call(\"Hello, world!\")")

        XCTAssertEqual(components, [
            .token("call", .call),
            .plainText("("),
            .token("\"Hello,", .string),
            .whitespace(" "),
            .token("world!\"", .string),
            .plainText(")")
        ])
    }

    func testStringLiteralWithEscapedQuote() {
        let components = highlighter.highlight("\"Hello \\\" World\"; call()")

        XCTAssertEqual(components, [
            .token("\"Hello", .string),
            .whitespace(" "),
            .token("\\\"", .string),
            .whitespace(" "),
            .token("World\"", .string),
            .plainText(";"),
            .whitespace(" "),
            .token("call", .call),
            .plainText("()")
        ])
    }

    func testStringLiteralWithAttribute() {
        let components = highlighter.highlight("\"@escaping\"")
        XCTAssertEqual(components, [.token("\"@escaping\"", .string)])
    }

    func testStringLiteralInterpolation() {
        let components = highlighter.highlight("\"Hello \\(variable) world \\(call())\"")

        XCTAssertEqual(components, [
            .token("\"Hello", .string),
            .whitespace(" "),
            .plainText("\\(variable)"),
            .whitespace(" "),
            .token("world", .string),
            .whitespace(" "),
            .plainText("\\("),
            .token("call", .call),
            .plainText("())"),
            .token("\"", .string)
        ])
    }

    func testMultiLineStringLiteral() {
        let components = highlighter.highlight("""
        let string = \"\"\"
        Hello \\(variable)
        \"\"\"
        """)

        XCTAssertEqual(components, [
            .token("let", .keyword),
            .whitespace(" "),
            .plainText("string"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("\"\"\"", .string),
            .whitespace("\n"),
            .token("Hello", .string),
            .whitespace(" "),
            .plainText("\\(variable)"),
            .whitespace("\n"),
            .token("\"\"\"", .string)
        ])
    }

    func testSingleLineRawStringLiteral() {
        let components = highlighter.highlight("""
        #"A raw string \\(withoutInterpolation) yes"#
        """)

        XCTAssertEqual(components, [
            .token("#\"A", .string),
            .whitespace(" "),
            .token("raw", .string),
            .whitespace(" "),
            .token("string", .string),
            .whitespace(" "),
            .token("\\(withoutInterpolation)", .string),
            .whitespace(" "),
            .token("yes\"#", .string)
        ])
    }

    func testDoubleLiteral() {
        let components = highlighter.highlight("let double = 1.13")

        XCTAssertEqual(components, [
            .token("let", .keyword),
            .whitespace(" "),
            .plainText("double"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("1.13", .number)
        ])
    }

    func testIntegerLiteralWithSeparators() {
        let components = highlighter.highlight("let int = 1_000_000")

        XCTAssertEqual(components, [
            .token("let", .keyword),
            .whitespace(" "),
            .plainText("int"),
            .whitespace(" "),
            .plainText("="),
            .whitespace(" "),
            .token("1_000_000", .number)
        ])
    }

    func testAllTestsRunOnLinux() {
        XCTAssertTrue(TestCaseVerifier.verifyLinuxTests((type(of: self)).allTests))
    }
}

extension LiteralTests {
    static var allTests: [(String, TestClosure<LiteralTests>)] {
        return [
            ("testStringLiteral", testStringLiteral),
            ("testStringLiteralPassedToFunction", testStringLiteralPassedToFunction),
            ("testStringLiteralWithEscapedQuote", testStringLiteralWithEscapedQuote),
            ("testStringLiteralWithAttribute", testStringLiteralWithAttribute),
            ("testStringLiteralInterpolation", testStringLiteralInterpolation),
            ("testMultiLineStringLiteral", testMultiLineStringLiteral),
            ("testSingleLineRawStringLiteral", testSingleLineRawStringLiteral),
            ("testDoubleLiteral", testDoubleLiteral),
            ("testIntegerLiteralWithSeparators", testIntegerLiteralWithSeparators)
        ]
    }
}
