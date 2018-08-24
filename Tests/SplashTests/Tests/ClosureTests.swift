/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest
import Splash

final class ClosureTests: SyntaxHighlighterTestCase {
    func testTrailingClosureWithArguments() {
        let components = highlighter.highlight("call() { arg in }")

        XCTAssertEqual(components, [
            .token("call", .call),
            .plainText("()"),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .plainText("arg"),
            .whitespace(" "),
            .token("in", .keyword),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testTrailingClosureWithoutParanthesis() {
        let components = highlighter.highlight("call { $0 }")

        XCTAssertEqual(components, [
            .token("call", .call),
            .whitespace(" "),
            .plainText("{"),
            .whitespace(" "),
            .plainText("$0"),
            .whitespace(" "),
            .plainText("}")
        ])
    }

    func testEmptyTrailingClosure() {
        let components = highlighter.highlight("call {}")

        XCTAssertEqual(components, [
            .token("call", .call),
            .whitespace(" "),
            .plainText("{}")
        ])
    }

    func testClosureArgumentWithSingleArgument() {
        let components = highlighter.highlight("func add(closure: (String) -> Void)")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("add(closure:"),
            .whitespace(" "),
            .plainText("("),
            .token("String", .type),
            .plainText(")"),
            .whitespace(" "),
            .plainText("->"),
            .whitespace(" "),
            .token("Void", .type),
            .plainText(")")
        ])
    }

    func testClosureArgumentWithMultipleArguments() {
        let components = highlighter.highlight("func add(closure: (String, Int) -> Void)")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("add(closure:"),
            .whitespace(" "),
            .plainText("("),
            .token("String", .type),
            .plainText(","),
            .whitespace(" "),
            .token("Int", .type),
            .plainText(")"),
            .whitespace(" "),
            .plainText("->"),
            .whitespace(" "),
            .token("Void", .type),
            .plainText(")")
        ])
    }

    func testEscapingClosureArgument() {
        let components = highlighter.highlight("func add(closure: @escaping () -> Void)")

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("add(closure:"),
            .whitespace(" "),
            .token("@escaping", .keyword),
            .whitespace(" "),
            .plainText("()"),
            .whitespace(" "),
            .plainText("->"),
            .whitespace(" "),
            .token("Void", .type),
            .plainText(")")
        ])
    }

    func testPassingClosureAsArgument() {
        let components = highlighter.highlight("object.call({ $0 })")

        XCTAssertEqual(components, [
            .plainText("object."),
            .token("call", .call),
            .plainText("({"),
            .whitespace(" "),
            .plainText("$0"),
            .whitespace(" "),
            .plainText("})")
        ])
    }

    func testAllTestsRunOnLinux() {
        XCTAssertTrue(TestCaseVerifier.verifyLinuxTests((type(of: self)).allTests))
    }
}

extension ClosureTests {
    static var allTests: [(String, TestClosure<ClosureTests>)] {
        return [
            ("testTrailingClosureWithArguments", testTrailingClosureWithArguments),
            ("testTrailingClosureWithoutParanthesis", testTrailingClosureWithoutParanthesis),
            ("testEmptyTrailingClosure", testEmptyTrailingClosure),
            ("testClosureArgumentWithSingleArgument", testClosureArgumentWithSingleArgument),
            ("testClosureArgumentWithMultipleArguments", testClosureArgumentWithMultipleArguments),
            ("testEscapingClosureArgument", testEscapingClosureArgument),
            ("testPassingClosureAsArgument", testPassingClosureAsArgument)
        ]
    }
}
