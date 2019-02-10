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

    func testHeaderdocComment() {
        let components = highlighter.highlight("""
        struct Foo {}
        /** Comment
            Hello!
        */ call()
        """)

        let expectedComponents: [OutputBuilderMock.Component] = [
            .token("struct", .keyword),
            .whitespace(" "),
            .plainText("Foo"),
            .whitespace(" "),
            .plainText("{}"),
            .whitespace("\n"),
            .token("/**", .comment),
            .whitespace(" "),
            .token("Comment", .comment),
            .whitespace("\n    "),
            .token("Hello!", .comment),
            .whitespace("\n"),
            .token("*/", .comment),
            .whitespace(" "),
            .token("call", .call),
            .plainText("()")
        ]

        XCTAssertEqual(components.count, expectedComponents.count)

        zip(components, expectedComponents).forEach {
            XCTAssertEqual($0, $1)
        }
    }

    func testVariedComments() {
        let components = highlighter.highlight("""
        struct Foo {}
        /** Headerdoc Comment
            Hello!
        */ call()

        /* Normal Comment */
        call()
        """)

        let expectedComponents: [OutputBuilderMock.Component] = [
            .token("struct", .keyword),
            .whitespace(" "),
            .plainText("Foo"),
            .whitespace(" "),
            .plainText("{}"),
            .whitespace("\n"),
            .token("/**", .comment),
            .whitespace(" "),
            .token("Headerdoc", .comment),
            .whitespace(" "),
            .token("Comment", .comment),
            .whitespace("\n    "),
            .token("Hello!", .comment),
            .whitespace("\n"),
            .token("*/", .comment),
            .whitespace(" "),
            .token("call", .call),
            .plainText("()"),
            .whitespace("\n\n"),
            .token("/*", .comment),
            .whitespace(" "),
            .token("Normal", .comment),
            .whitespace(" "),
            .token("Comment", .comment),
            .whitespace(" "),
            .token("*/", .comment),
            .whitespace("\n"),
            .token("call", .call),
            .plainText("()")
        ]

        XCTAssertEqual(components.count, expectedComponents.count)

        zip(components, expectedComponents).forEach {
            XCTAssertEqual($0, $1)
        }
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
            ("testHeaderdocComment", testHeaderdocComment),
            ("testVariedComments", testVariedComments)
        ]
    }
}
