/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest
import Splash

final class CommentTests: SyntaxHighlighterTestCase {
    func testSingleLineComment() {
        let components = highlighter.highlight("call() // Hello call() var \"string\"\ncall()")

        XCTAssertEqual(components, [
            .token("call", .call),
            .plainText("()"),
            .whitespace(" "),
            .token("//", .comment),
            .whitespace(" "),
            .token("Hello", .comment),
            .whitespace(" "),
            .token("call()", .comment),
            .whitespace(" "),
            .token("var", .comment),
            .whitespace(" "),
            .token("\"string\"", .comment),
            .whitespace("\n"),
            .token("call", .call),
            .plainText("()")
        ])
    }

    func testMultiLineComment() {
        let components = highlighter.highlight("""
        struct Foo {}
        /* Comment
            Hello!
        */ call()
        """)

        XCTAssertEqual(components, [
            .token("struct", .keyword),
            .whitespace(" "),
            .plainText("Foo"),
            .whitespace(" "),
            .plainText("{}"),
            .whitespace("\n"),
            .token("/*", .comment),
            .whitespace(" "),
            .token("Comment", .comment),
            .whitespace("\n    "),
            .token("Hello!", .comment),
            .whitespace("\n"),
            .token("*/", .comment),
            .whitespace(" "),
            .token("call", .call),
            .plainText("()")
        ])
    }

    func testMultiLineCommentWithConsecutiveAsterisks() {
        let components = highlighter.highlight("""
        /**
         Splash
         */
        struct Foo {}
        """)

        XCTAssertEqual(components, [
            .token("/*", .comment),
            .token("*", .comment),
            .whitespace("\n "),
            .token("Splash", .comment),
            .whitespace("\n "),
            .token("*/", .comment),
            .whitespace("\n"),
            .token("struct", .keyword),
            .whitespace(" "),
            .plainText("Foo"),
            .whitespace(" "),
            .plainText("{}")
        ])
    }

    func testAllTestsRunOnLinux() {
        XCTAssertTrue(TestCaseVerifier.verifyLinuxTests((type(of: self)).allTests))
    }
}

extension CommentTests {
    static var allTests: [(String, TestClosure<CommentTests>)] {
        return [
            ("testSingleLineComment", testSingleLineComment),
            ("testMultiLineComment", testMultiLineComment),
            ("testMultiLineCommentWithConsecutiveAsterisks", testMultiLineCommentWithConsecutiveAsterisks)
        ]
    }
}
