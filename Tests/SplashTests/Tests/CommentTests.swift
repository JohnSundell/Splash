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

    func testMultiLineCommentWithDoubleAsterisks() {
        let components = highlighter.highlight("""
        struct Foo {}
        /** Comment
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
        ])
    }

    func testMutliLineDocumentationComment() {
        let components = highlighter.highlight("""
        /**
         *  Documentation
         */
        class MyClass {}
        """)

        XCTAssertEqual(components, [
            .token("/**", .comment),
            .whitespace("\n "),
            .token("*", .comment),
            .whitespace("  "),
            .token("Documentation", .comment),
            .whitespace("\n "),
            .token("*/", .comment),
            .whitespace("\n"),
            .token("class", .keyword),
            .whitespace(" "),
            .plainText("MyClass"),
            .whitespace(" "),
            .plainText("{}")
        ])
    }

    func testCommentStartingWithPunctuation() {
        let components = highlighter.highlight("//.call()")
        XCTAssertEqual(components, [.token("//.call()", .comment)])
    }

    func testCommentEndingWithComma() {
        let components = highlighter.highlight("""
        // Hello,
        class World {}
        """)

        XCTAssertEqual(components, [
            .token("//", .comment),
            .whitespace(" "),
            .token("Hello,", .comment),
            .whitespace("\n"),
            .token("class", .keyword),
            .whitespace(" "),
            .plainText("World"),
            .whitespace(" "),
            .plainText("{}")
        ])
    }

    func testCommentPrecededByComma() {
        let components = highlighter.highlight("""
        func find(
            string: String,//TODO: Remove
            options: Options
        )
        """)

        XCTAssertEqual(components, [
            .token("func", .keyword),
            .whitespace(" "),
            .plainText("find("),
            .whitespace("\n    "),
            .plainText("string:"),
            .whitespace(" "),
            .token("String", .type),
            .plainText(","),
            .token("//TODO:", .comment),
            .whitespace(" "),
            .token("Remove", .comment),
            .whitespace("\n    "),
            .plainText("options:"),
            .whitespace(" "),
            .token("Options", .type),
            .whitespace("\n"),
            .plainText(")")
        ])
    }
        
    func testCommentWithNumber() {
        let components = highlighter.highlight("// 1")

        XCTAssertEqual(components, [
            .token("//", .comment),
            .whitespace(" "),
            .token("1", .comment)
        ])
    }

    func testCommentWithNoWhiteSpaceToPunctuation() {
        let components = highlighter.highlight("""
        (/* Hello */)
        .// World
        (/**/)
        """)

         XCTAssertEqual(components, [
            .plainText("("),
            .token("/*", .comment),
            .whitespace(" "),
            .token("Hello", .comment),
            .whitespace(" "),
            .token("*/", .comment),
            .plainText(")"),
            .whitespace("\n"),
            .plainText("."),
            .token("//", .comment),
            .whitespace(" "),
            .token("World", .comment),
            .whitespace("\n"),
            .plainText("("),
            .token("/**/", .comment),
            .plainText(")"),
        ])
    }

    func testCommentsNextToCurlyBrackets() {
        let components = highlighter.highlight("""
        call {//commentA
        }//commentB
        """)

        XCTAssertEqual(components, [
            .token("call", .call),
            .whitespace(" "),
            .plainText("{"),
            .token("//commentA", .comment),
            .whitespace("\n"),
            .plainText("}"),
            .token("//commentB", .comment)
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
            ("testMultiLineCommentWithDoubleAsterisks", testMultiLineCommentWithDoubleAsterisks),
            ("testMutliLineDocumentationComment", testMutliLineDocumentationComment),
            ("testCommentStartingWithPunctuation", testCommentStartingWithPunctuation),
            ("testCommentEndingWithComma", testCommentEndingWithComma),
            ("testCommentPrecededByComma", testCommentPrecededByComma),
            ("testCommentWithNumber", testCommentWithNumber),
            ("testCommentWithNoWhiteSpaceToPunctuation", testCommentWithNoWhiteSpaceToPunctuation),
            ("testCommentsNextToCurlyBrackets", testCommentsNextToCurlyBrackets)
        ]
    }
}
